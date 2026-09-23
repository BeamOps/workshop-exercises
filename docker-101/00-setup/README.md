# Setup & environment check

Do this **before** the workshop, on good wifi. It gets your machine ready and
confirms everything works, so we don't lose the first hour to installs and
downloads.

At the end, run `./validate` and get a green light.

## 1. Docker

Install Docker and make sure it's **running** (the whale icon / daemon is up).

| OS | Install |
|----|---------|
| macOS | `brew install --cask docker` (then launch Docker Desktop), or download from [docker.com](https://www.docker.com/products/docker-desktop) |
| Windows | [Docker Desktop](https://www.docker.com/products/docker-desktop) (WSL 2 backend recommended) |
| Linux | [Docker Engine + Compose plugin](https://docs.docker.com/engine/install/) (the `docker compose` v2 plugin, not the old `docker-compose`) |

## 2. Elixir (via mise)

You only need this for the OTP release exercise, but set it up now. We use
[mise](https://mise.jdx.dev) to install the exact versions this repo pins in
[`../mise.toml`](../mise.toml).

```
# install mise: https://mise.jdx.dev/getting-started.html
cd ..            # the docker-101 directory (where mise.toml lives)
mise install     # installs the pinned Erlang + Elixir
```

Already have Elixir another way (asdf, system package)? That's fine, the check
below only cares that `elixir` and `mix` are on your PATH, not how they got there.

## 3. Pre-pull the images

So we're not all downloading at once on the day:

```
docker pull elixir
docker pull postgres:16
```

## Check your work

```
./validate
```

Green means you're ready for Docker 101.

## Then see Docker for yourself

The check gives you the green light. Run these yourself too, so you know what
each one shows:

```
docker version          # CLI (client) + engine (daemon) versions, and whether they can talk
docker info             # engine state: containers, images, storage driver, resources
docker run hello-world  # pulls and runs a tiny container end to end
```
