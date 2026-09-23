# Workshop exercises

Hands-on exercises for the BEAMOps workshops. Clone this once and work through
the exercises for your workshop, each one has a self-check you can run to confirm
you got it right.

## Workshops

- [`docker-101/`](docker-101/) — Docker 101 (containers, images, releases, Compose)
- [`terraform-101/`](terraform-101/) — Terraform 101 _(coming soon)_

## Before the workshop

On good wifi (not the venue's), the night before:

1. Install and start **Docker Desktop** (macOS/Windows) or Docker Engine + the
   Compose v2 plugin (Linux). Confirm it works:
   ```
   docker run hello-world
   ```
2. **Pre-pull the images** so we're not all downloading them at once on the day:
   ```
   docker pull elixir
   docker pull postgres:18
   ```
3. **Clone this repo:**
   ```
   git clone <repo-url> && cd workshop-exercises
   ```

## How the exercises work

Each exercise is a self-contained directory:

```
<act>/<NN-exercise-name>/
  README.md    # the goal and the steps
  start/       # your starting point — work in here
  solution/    # a reference solution (peek if you're stuck)
  validate     # run ./validate to check your work
```

Work in `start/`, follow the `README.md`, then run the self-check from the
exercise directory:

```
cd docker-101/act-1-understanding-containers/01-run-and-manage-containers
./validate
```

A green run means you're done. A red check comes with a hint.

## Requirements

- Docker (Desktop, or Engine + Compose v2)
- `bash` and `git` (the validators are plain shell, no language toolchain needed)
- `curl` for the exercises that check a running app

You do **not** need Elixir or Erlang installed, everything runs inside
containers.
