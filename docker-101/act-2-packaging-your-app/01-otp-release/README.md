# Build an OTP release

**Goal:** Package the starter app as a production **OTP release** — a self-contained
binary bundling your app, its dependencies, and the Erlang VM — and boot it to
confirm it runs without Elixir on the PATH.

You work in the shared app from setup: `docker-101/starter-app/starter_app`.
Acts 2 and 3 all build on it.

> **Prerequisite:** run `mise install` in `docker-101/` (setup step 2) so `mix`
> uses the Elixir/OTP pinned in `mise.toml`. A release must be built with the same
> OTP version as the Docker base image, or it won't run inside the container.

## Steps

1. Move into the app:
   ```sh
   cd docker-101/starter-app/starter_app
   ```
   No such folder? You haven't generated the app yet — follow
   [`../../starter-app/README.md`](../../starter-app/README.md) first (it's a
   one-time setup step, done once and reused across Acts 2 and 3).
2. Generate the release files (adds `rel/` and release config to the project):
   ```sh
   mix phx.gen.release
   ```
   `phx.gen.release` is provided by the phoenix dependency inside the app — that's
   why you run it here, not globally. Plain, no `--docker`; you'll write the
   Dockerfile yourself in the next exercise.
3. Build a production release:
   ```sh
   MIX_ENV=prod mix release
   ```
   It assembles into `_build/prod/rel/starter_app/`.
4. Boot the binary to prove it's self-contained:
   ```sh
   _build/prod/rel/starter_app/bin/starter_app version
   ```
   You should see `starter_app <version>` printed — no `mix`, no Elixir needed to run it.
5. Have a look at everything the release can do:
   ```sh
   _build/prod/rel/starter_app/bin/starter_app
   ```
   It lists commands like `start`, `daemon`, `remote`, `eval`, `rpc`. You'll actually
   *serve* this app for real in Act 3, once Docker Compose gives it a database.

## Check your work

```sh
./validate
```
