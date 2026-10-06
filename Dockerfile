# EVE Frontier Club Frontend - Docker Build (Development/Testing Only)
# This Dockerfile is provided for local development and testing purposes.
# Production deployment uses direct Dart runtime without Docker.
# 
# Multi-stage build for EVE Frontier Club
# Stage 1: Build
FROM dart:3.1 as builder

WORKDIR /app
COPY . .

RUN dart pub get
RUN dart pub run build_runner build --release

# Stage 2: Runtime
FROM google/dart-runtime:3.1

WORKDIR /app

# Copy only built artifacts from builder
COPY --from=builder /app/lib ./lib
COPY --from=builder /app/build ./build
COPY --from=builder /app/pubspec.* ./

# Install dependencies in runtime
RUN dart pub get --offline

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Run the app
CMD ["dart", "bin/main.dart"]
