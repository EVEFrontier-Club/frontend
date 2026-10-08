# EVE Frontier Club Frontend - Production Dockerfile
#
# Multi-stage build for the Jaspr SSR frontend.
# Build stage uses Flutter SDK (required by jaspr: mode: server, flutter: embedded).
# Runtime stage is a minimal Debian image with only the compiled binary and web assets.

# Stage 1: Build
FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

# Copy dependency manifests first for better layer caching.
# pubspec.lock is deliberately NOT copied: it is gitignored, so it is absent from a
# clean checkout / CI build context and `COPY` would fail on the missing source. The
# image therefore resolves the latest versions allowed by pubspec.yaml at build time.
COPY pubspec.yaml ./
RUN flutter pub get

# Copy rest of source
COPY . .

# Build the Jaspr app (NOT build_runner build)
RUN dart run jaspr_cli:jaspr build

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
