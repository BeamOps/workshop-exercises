FROM hexpm/elixir:1.20.4-erlang-29.1.1-debian-bookworm-20260918-slim

WORKDIR /app
ENV MIX_ENV=prod

RUN apt-get update -y && apt-get install -y build-essential git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./
RUN mix deps.get --only prod
RUN mix deps.compile

# Copy only what the release needs — never `COPY . .`, which would drag the host's
# _build/ into this Linux image and cause "Exec format error" at runtime.
COPY config config
COPY lib lib
COPY priv priv
COPY assets assets
COPY rel rel
RUN mix compile
RUN mix assets.deploy
RUN mix release

EXPOSE 4000

CMD ["/app/_build/prod/rel/starter_app/bin/server"]
