# EVE Frontier Club Frontend - Production Dockerfile
#
# Multi-stage build for the Jaspr SSR frontend.
# Build stage uses Flutter SDK (required by jaspr: mode: server, flutter: embedded).
# Runtime stage is a minimal Debian image with only the compiled binary and web assets.

# Stage 1: Build
#
# The toolchain comes from the shared, pinned image maintained in
# `dip-develop/jaspr-build-image`. Its tag *is* the pin: Flutter 3.44.9 (Dart 3.12.2
# bundled), `jaspr_cli 0.23.5` activated as `jaspr` on PATH, and the Tailwind v4 CLI.
# Nothing here floats on `:stable` or `:latest`.
#
# Flutter is pinned deliberately, not incidentally: `build_web_compilers` is pinned
# to exactly 4.4.19 and every `build_modules` 5.x release caps its Dart SDK
# constraint at `<3.13.0-z`, so this package cannot resolve on a newer Flutter:
# `:stable` (currently 3.47.6 / Dart 3.13.5) makes `flutter pub get` fail outright.
# Bumping the tag is a coupled change that requires reviewing the pubspec.yaml pins
# alongside it — and then republishing the shared image.
#
# The image is `linux/amd64` only, on purpose: Flutter publishes no linux-arm64
# archive, so an arm64 variant would be an arm64 base carrying an x64 SDK. Build
# this repo's image on an amd64 builder.
FROM ghcr.io/dip-develop/jaspr-build-image:flutter-3.44.9-jaspr-0.23.5-tailwind-4.3.0 AS builder

WORKDIR /app

# Copy dependency manifests first for better layer caching.
# pubspec.lock is deliberately NOT copied: it is gitignored, so it is absent from a
# clean checkout / CI build context and `COPY` would fail on the missing source. The
# image therefore resolves the latest versions allowed by pubspec.yaml at build time.
COPY pubspec.yaml ./
RUN flutter pub get

# Copy rest of source
COPY . .

# Build the Jaspr app (NOT build_runner build).
# `jaspr build`, not a `dart run` of the `jaspr_cli` package: the shared image
# activates `jaspr_cli 0.23.5` and puts `jaspr` on PATH, whereas `dart run` needs
# the package resolvable through `.dart_tool/package_config.json` — it is
# declared in neither dependency block here, so it only resolves transitively.
RUN jaspr build

# Stage 2: Runtime
FROM debian:bookworm-slim

# Install curl for healthcheck
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user with UID 1001
RUN groupadd --gid 1001 appgroup \
    && useradd --uid 1001 --gid appgroup --shell /bin/false appuser

WORKDIR /app

# Copy only the built artifacts (app.exe + web assets)
COPY --from=builder /app/build/jaspr/app.exe ./
COPY --from=builder /app/build/jaspr/web ./web

# Set ownership for non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose the default Jaspr serve port
EXPOSE 8080

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Run the compiled binary
ENTRYPOINT ["./app.exe"]
