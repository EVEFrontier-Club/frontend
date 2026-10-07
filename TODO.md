# TODO

## Jaspr 0.23.5 upgrade (issue #3)

- [x] Resolve the toolchain blocker: install Flutter 3.44.9 (Dart 3.12.2) side by side at
      `/home/develop/flutter-3.44.9`, since `jaspr_tailwind` → `build_modules ^5.0.4`
      cannot resolve on the default Dart 3.13.5
- [x] `pubspec.yaml`: `jaspr` `^0.23.5`, `jaspr_builder` `^0.23.5`, `jaspr_router` `^0.9.0`,
      `jaspr_flutter_embed` `^0.4.11`, `build_runner` `^2.15.1`
- [x] Declare `jaspr_lints` as a dev_dependency — `analysis_options.yaml` configured the
      plugin but it was never in `pubspec.yaml`, so it never loaded
- [x] `analysis_options.yaml`: plugin `version:` to match the declared `jaspr_lints`
- [x] Pin `build_web_compilers: 4.4.19` — `>= 4.5.0` duplicates `build_modules`'`
      `module_library` builder and breaks `build_runner build` (dart-lang/build#4963).
      Pre-existing breakage, not a regression from the bump.
- [x] Regenerate `main.server.options.dart` / `main.client.options.dart` via `build_runner`
- [x] `/home/develop/flutter-3.44.9/bin/dart analyze` — clean. Use `dart analyze`, not
      `flutter analyze`: the latter does not load analyzer plugins.
- [ ] `dart run jaspr_cli:jaspr build` to prove the build stack is coherent
- [ ] Commit in 3 chunks and open the PR against `main`

## Blocking / follow-ups

- [ ] **Backend API is miswired.** `TrustService` calls `http://localhost:8081/trust/...`;
      the backend serves `TrustIndexRoute` at `/api/v1/trust-index/` on its webServer
      (8082 in dev). `BACKEND_URL` in `.env.example` / `docker-compose.yml` is dead config.
      The module's route is still `throw UnimplementedError()` anyway.
- [ ] `jaspr_builder`'s `client_options` builder shells out to `flutter packages get` using
      whatever `flutter` is on PATH. With the 3.44.9 toolchain that resolves to Flutter
      3.47.6 / Dart 3.13.5, which cannot satisfy `build_web_compilers 4.4.19`, so the
      builder prints a warning. Harmless today (no Flutter web plugins, so it returns an
      empty list), but it would matter if a real Flutter web plugin is ever added.
- [ ] `Dockerfile` is broken: `dart:3.1`, `dart pub run build_runner build`, no Flutter,
      `CMD ["dart", "bin/main.dart"]` with no `bin/` directory
- [ ] `.github/workflows/deploy.yml` is broken: `cd frontend` and `frontend/build/` do not
      exist (the repo root IS the frontend), installs Dart only despite `flutter: embedded`,
      uses deprecated `dart pub run`
- [ ] `.deployment/evefrontier-club.service` runs the same non-existent `bin/main.dart`
- [ ] `.deployment/nginx.conf` proxies `/api/` to the Jaspr server, not the backend
- [ ] Replace hardcoded hex values in `lib/pages/*.dart` with the `web/styles.tw.css` tokens
- [ ] Consider adopting `jaspr: styles: standalone` (new in 0.23, needs a `<link>` in
      `main.server.dart`'s `Document`)
