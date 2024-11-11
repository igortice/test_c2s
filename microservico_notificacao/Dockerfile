# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.2.6
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Set the working directory for the Rails app
WORKDIR /microservico_notificacao

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 postgresql-client bash \
    bash-completion libffi-dev tzdata && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Configure environment for development
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle"

# Build stage for dependencies
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set frozen false && bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy application code
COPY . .

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /microservico_notificacao /microservico_notificacao

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint for database preparation
ENTRYPOINT ["/microservico_notificacao/bin/docker-entrypoint"]

# Expose port and start the server
EXPOSE ${MN_RAILS_PORT}
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
