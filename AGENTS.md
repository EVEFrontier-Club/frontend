# AGENTS.md — frontend (Jaspr SSR)

See `../AGENTS.md` for cross-stack context.

## Entrypoints and generated files

Jaspr owns the entrypoints: `lib/main.server.dart` (SSR / pre-render) and
`lib/main.client.dart` (hydration). Both import `lib/main.*.options.dart`, which is
**generated — do not edit**. `lib/app.dart` holds the `jaspr_router` `Router`; adding a
route means editing it there, not in the entrypoints.

Components that perform `http` calls must be client-only: `lib/pages/leaderboard.dart`
uses `@client` + `initState`. Letting such a component render on the server makes the
server render perform the fetch (or fail silently).

## Commands

**Use `/home/develop/flutter-3.44.9/bin/flutter`, not the `flutter`/`dart` on PATH.**
The default Dart 3.13.5 cannot resolve this package: `jaspr_tailwind` depends on
`build_modules ^5.0.4`, and every `build_modules` 5.x release caps its SDK constraint
at `<3.13.0-z`. Flutter 3.44.9 (bundling Dart 3.12.2) is installed side by side at
`/home/develop/flutter-3.44.9` for this purpose. Do not replace `/home/develop/flutter`
(other projects in this container use it).

```bash
/home/develop/flutter-3.44.9/bin/flutter pub get
/home/develop/flutter-3.44.9/bin/flutter analyze
/home/develop/flutter-3.44.9/bin/dart run jaspr_cli:jaspr build   # prod build
dart run jaspr:serve                      # http://localhost:8080, hot reload
dart run jaspr:serve -- --port 8082       # flags go after `--`
dart format .
```

`jaspr build` writes `build/jaspr/app.exe` plus a `web/` asset folder — deploy both
together. Because `pubspec.yaml` sets `jaspr: mode: server` **with `flutter: embedded`**,
any build image needs the Flutter SDK (`ghcr.io/cirruslabs/flutter:3.44.9`), not just
Dart. That tag is pinned, not incidental: `:stable` now resolves to a Dart the pin below
forbids, so a floating tag breaks `flutter pub get` outright. Retiring the
`build_web_compilers` pin and the Flutter tag is a single coupled change.

`build_web_compilers` is pinned to exactly **4.4.19**. Two independent reasons, both
hard constraints:
- 4.8.1+ requires Dart `>=3.13.0-107.0.dev`, above the pinned Dart 3.12.2.
- `>= 4.5.0` duplicates `build_modules`' `module_library` builder (`.dart` →
  `.module.library`, `auto_apply: all_packages`), which collides with the copy
  `jaspr_tailwind` pulls in via `build_modules` — see [dart-lang/build#4963](https://github.com/dart-lang/build/issues/4963).
  This made `build_runner build` fail outright. Neither package can be dropped:
  `build_modules` is reachable only via `jaspr_tailwind`, and `build_web_compilers` is a
  dependency of `jaspr` itself.

`build_runner` is capped at `2.15.1` because every 2.15.2+ requires `analyzer >=13.3.0`,
while `jaspr_builder` and `jaspr_lints` both need `analyzer ^12.1.0`. The caret permits
newer 2.16.x; pub backtracks automatically if that ever unblocks.

There are no tests in this package (no `test/` directory, despite `flutter_test` being a
dev dependency).

## The jaspr_lints plugin is now live — gate on `dart analyze`

`analysis_options.yaml` configured the `jaspr_lints` plugin for a long time, but
`jaspr_lints` was never declared in `pubspec.yaml`, so it was unresolvable and the
analyzer **silently ignored it**. It is now a dev_dependency; keep the plugin `version:`
key in `analysis_options.yaml` in sync with that constraint.

**`flutter analyze` does not load analyzer plugins** — verified here with a positive
control: on the same file and same resolved packages, `flutter analyze` reported 1 issue
while `dart analyze` reported 3 including `prefer_html_components`. A green
`flutter analyze` therefore proves nothing about the Jaspr lints. Use
`/home/develop/flutter-3.44.9/bin/dart analyze` as the gate.

`jaspr_lints` is now declared as a dev_dependency, so the plugin loads. **Gate on
`dart analyze`, not `flutter analyze`** — verified with a positive control in this repo:
`flutter analyze` does not load analyzer plugins at all and stayed green while
`dart analyze` correctly reported `prefer_html_components` on the same file. So
`flutter analyze` being clean proves nothing about the Jaspr lints.

The codebase is genuinely clean of all three rules (`prefer_html_components`,
`sort_children_last`, `styles_ordering`): it already uses the html-style constructors
(`div(...)`, `nav(...)`, `header(...)`) rather than `Component.element`, and the `@css`
blocks are conventionally ordered. `jaspr_lints` 0.7.x also adds `unsafe_imports`, which
is always-on and not toggleable via the `diagnostics:` block; `package:http/http.dart` is
in neither its server- nor client-unsafe list, so `lib/services/trust_service.dart` stays
clean.

## Styling

Tailwind v4 in CSS-first mode via `jaspr_tailwind`. Theme tokens (`--color-*`,
`--font-*`, `--radius-*`, `--shadow-*`, gradients, transitions) live in the `@theme`
block of `web/styles.tw.css`; component classes (`.card`, `.btn-primary`, `.section`) in
its `@layer` blocks. Prefer tokens over the hardcoded hex values that have accumulated in
`lib/pages/*.dart`.

`jaspr_tailwind` compiles `web/styles.tw.css` with `build_to: cache`, so its output lands
in `.dart_tool/build/generated/evefrontier_club_frontend/web/styles.css` — **not** in the
source tree. There is no `web/styles.css` to edit, commit, or ignore; `jaspr build` copies
the cache artifact into the deploy output, and `main.server.dart` links it as `styles.css`
in `<head>`. Never hand-write that file. (`README.md` points at a stale path,
`web/styles/tailwind.css`.)

Components also carry `@css` blocks of type-safe CSS-in-Dart (`css('&').styles(...)`).
Formatter `page_width: 120`.

## Backend API is miswired — don't trust the data

`lib/services/trust_service.dart` defaults to `baseUrl = 'http://localhost:8081'` and
requests `$baseUrl/trust/leaderboard`, `/trust/{playerId}`, `/trust/explain/{playerId}`.
The backend actually serves `TrustIndexRoute` at `/api/v1/trust-index/` on its
**webServer** (8082 in dev, not 8081).

`BACKEND_URL` in `.env.example` and `docker-compose.yml` is dead config: no Dart code
reads it (no `String.fromEnvironment` anywhere), and `TrustService()` is always
constructed with no arguments. Make the base URL configurable and correct the path before
treating leaderboard output as real.

`docker-compose.yml` here is a local full-stack convenience whose `backend` service is a
**httpbin mock**, not the real Serverpod API.

## Stale Docker/CI/deploy artifacts

Treat these as broken until fixed — they are not working references:

- `Dockerfile`: `dart:3.1`, `dart pub run build_runner build` (Jaspr needs
  `jaspr build`), no Flutter, and `CMD ["dart", "bin/main.dart"]` when there is no
  `bin/` directory.
- `.github/workflows/deploy.yml`: runs `cd frontend` and uploads `frontend/build/` even
  though the repo root *is* the frontend, installs Dart only, and uses the deprecated
  `dart pub run build_runner build`. Intended target is rsync of build artifacts to
  `/var/www/evefrontier-club/` then `systemctl restart evefrontier-club`.
- `.deployment/evefrontier-club.service`: `ExecStart=.../dart bin/main.dart` — same
  non-existent entrypoint.
- `.deployment/*.md`: long-form deployment plans that disagree with the code above.

`.deployment/nginx.conf` proxies `/api/` and all unmatched paths to `127.0.0.1:8080`
(the Jaspr server), so a `/api/v1/trust-index/` browser request lands on the frontend,
not on the backend — relevant when wiring the two together behind one host.
