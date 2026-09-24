# --- Builder stage: compile everything (this is your Act 2 Dockerfile) ---
# Name this stage so the runner can copy from it.
FROM hexpm/elixir:1.20.4-erlang-29.1.1-debian-bookworm-20260918-slim AS builder

ENV MIX_ENV=prod
WORKDIR /app

RUN apt-get update -y && apt-get install -y build-essential git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./
RUN mix deps.get --only prod
RUN mix deps.compile

COPY . .
RUN mix compile
RUN mix assets.deploy
RUN mix release

# --- Runner stage: a tiny image with just the release ---
# Start from a minimal base with NO Elixir/Mix (a plain Debian slim works).
FROM debian:bookworm-slim AS runner

# The release needs a few shared libraries at runtime, but none of the build tools.
RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses6 locales ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Generate a UTF-8 locale so the Erlang VM uses utf8 (not latin1) name encoding.
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

WORKDIR /app

# Copy ONLY the compiled release out of the builder stage. Nothing else comes across.
COPY --from=builder /app/_build/prod/rel/starter_app ./

# In the runner the release lives at /app, so the server script is /app/bin/server.
CMD ["bin/server"]
