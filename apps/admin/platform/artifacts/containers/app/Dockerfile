# syntax=docker/dockerfile:1.5

ARG RUBY_VERSION=4.0
ARG BUNDLE_DEPLOYMENT=1
ARG BUNDLE_PATH=/usr/local/bundle
ARG BUNDLE_WITHOUT=development:test
ARG BUNDLE_JOBS=4
ARG BUNDLE_RETRY=3
ARG UID=1000
ARG GID=1000

# Base runtime image: minimal dependencies only.
FROM ruby:${RUBY_VERSION}-alpine AS base

WORKDIR /app

# Bundler defaults for deterministic builds.
ENV BUNDLE_DEPLOYMENT="${BUNDLE_DEPLOYMENT}" \
    BUNDLE_PATH="${BUNDLE_PATH}" \
    BUNDLE_WITHOUT="${BUNDLE_WITHOUT}" \
    BUNDLE_JOBS="${BUNDLE_JOBS}" \
    BUNDLE_RETRY="${BUNDLE_RETRY}"

# Runtime packages (no build toolchain).
RUN apk add --no-cache \
  tzdata \
  libpq \
  yaml

# Build stage with native build tooling.
FROM base AS build

# Avoid make -j0 on Alpine during native gem builds.
ENV MAKEFLAGS="-j1"

# Build dependencies for native gems.
RUN apk add --no-cache \
  build-base \
  git \
  gmp-dev \
  linux-headers \
  pkgconf \
  yaml-dev \
  postgresql-dev

# Install gems first for better layer caching.
COPY Gemfile Gemfile.lock ./
RUN --mount=type=cache,target=/usr/local/bundle \
  bundle install && \
  rm -rf /usr/local/bundle/cache /root/.bundle/cache /usr/lib/apk/cache

# Copy application code.
COPY . .

RUN chmod +x /app/platform/artifacts/containers/app/entrypoint.sh

# Dev stage with tooling for local debugging.
FROM build AS dev

RUN apk add --no-cache \
  bash \
  bind-tools \
  curl \
  vim

# Test stage for CI pipelines.
FROM base AS test

# Include all groups when running tests.
ENV BUNDLE_WITHOUT=""

# Avoid make -j0 on Alpine during native gem builds.
ENV MAKEFLAGS="-j1"

# Build dependencies for native gems in tests.
RUN apk add --no-cache \
  build-base \
  git \
  gmp-dev \
  linux-headers \
  pkgconf \
  yaml-dev \
  postgresql-dev

# Install test gems.
COPY Gemfile Gemfile.lock ./
RUN --mount=type=cache,target=/usr/local/bundle \
  bundle install && \
  rm -rf /usr/local/bundle/cache /root/.bundle/cache /usr/lib/apk/cache

# Copy application code.
COPY . .

CMD ["bundle", "exec", "rake", "spec"]

# Final runtime image.
FROM base AS final

ARG UID=1000
ARG GID=1000

# Bring built gems and code from build stage.
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app

# Run as non-root user.
RUN addgroup -g "$GID" -S app && adduser -S app -G app -u "$UID" && \
  chown -R app:app /app

USER app

ENTRYPOINT ["/app/platform/artifacts/containers/app/entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
