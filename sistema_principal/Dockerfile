# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.2.6
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Set the working directory for the Rails app
WORKDIR /sistema_principal

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl libjemalloc2 libvips postgresql-client bash \
    bash-completion libffi-dev tzdata nodejs npm gnupg && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install --no-install-recommends -y yarn && \
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
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Install JavaScript dependencies
RUN yarn install
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /sistema_principal /sistema_principal

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/sistema_principal/bin/docker-entrypoint"]

# Expose port and start the server
EXPOSE ${SP_RAILS_PORT}
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
