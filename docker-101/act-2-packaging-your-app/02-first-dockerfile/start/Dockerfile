# Base image with Elixir + Erlang already installed.
# Use the same Elixir/OTP you're pinned to in docker-101/mise.toml.
FROM ???

# Where the app lives inside the image.
WORKDIR ???

# Build a production release.
ENV MIX_ENV=???

# The slim image is minimal — install the OS tools the build needs
# (git to fetch git deps like heroicons; build tools to compile native deps).
RUN apt-get update -y && apt-get install -y build-essential git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Elixir images don't ship Hex/rebar — install them before fetching deps.
RUN mix local.hex --force && mix local.rebar --force

# Copy the dependency manifests FIRST and fetch/compile deps, so this layer stays
# cached until mix.exs / mix.lock actually change.
COPY ??? ???
RUN mix deps.get --only prod
RUN mix deps.compile

# Now the rest of the source. Compile first — Phoenix 1.8 extracts colocated
# JS/CSS during compilation, and the asset build imports it — then assets + release.
COPY . .
RUN mix compile
RUN mix assets.deploy
RUN mix release

# Document the port the app serves on.
EXPOSE ???

# Start the release when the container runs (use the full path to the server script).
CMD ???
