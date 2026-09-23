# Starter app

A deliberately small Phoenix application used by the Act 2 and Act 3 exercises
(releases, Dockerfiles, multi-stage builds, Compose). One shared app means you
learn Docker, not a new codebase, at each step.

## You generate it — we don't ship it

The app is **not committed**. You generate it yourself (once) and it stays
gitignored right here (`starter-app/starter_app/`). Everyone runs the same pinned
commands, so the app name (`starter_app`) and its paths are identical for all
attendees — which is what lets the exercise validators rely on them. Do this during
`00-setup`, on good wifi, so dependencies download before the workshop.

### 1. Activate the pinned toolchain

mise reads `docker-101/mise.toml`, so from `docker-101/`:

```sh
cd docker-101
mise install            # installs the pinned Erlang + Elixir (no-op if already done)
elixir --version        # should report Elixir 1.20.4 (compiled for OTP 29)
```

### 2. Install Hex, rebar, and the Phoenix generator

A fresh Elixir has no Hex or rebar yet — do all three (one-time, per machine):

```sh
mix local.hex --force                          # Hex package manager
mix local.rebar --force                        # rebar (builds Erlang deps)
mix archive.install hex phx_new 1.8.14 --force # the `mix phx.new` generator (pinned)
```

We pin `phx_new` to `1.8.14` so everyone scaffolds the same app, whenever they run setup.

### 3. Generate the app

```sh
cd starter-app
mix phx.new starter_app --no-mailer --no-dashboard --install
```

`--install` fetches and compiles dependencies for you, so there's no prompt to answer.
Keep Ecto + Postgres (the Act 3 Compose exercise needs a database). Use the name
`starter_app` exactly. Phoenix's default `/` route already returns 200, so the exercise
validators can just check the app is serving.

## How the exercises use it

Every Act 2/3 exercise works on this same `starter-app/starter_app` tree, adding
one artifact at a time — a release, then a Dockerfile, then a `compose.yaml`. If you
fall behind, each exercise's `solution/` holds the finished artifact to copy in and
keep going. The `start/` folders hold scaffolding (a partial Dockerfile, and so on),
never the app itself.
