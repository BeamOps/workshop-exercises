# --- Builder stage: compile everything ---
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
FROM debian:bookworm-slim AS runner

RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses6 locales ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# UTF-8 locale so the Erlang VM uses utf8 (not latin1) name encoding.
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

WORKDIR /app

# Copy only the compiled release out of the builder stage.
COPY --from=builder /app/_build/prod/rel/starter_app ./

CMD ["bin/server"]
