# Your first Dockerfile

**Goal:** Complete a partially-written Dockerfile so the starter app builds into an
image — someone can clone the repo, run `docker build`, and get a working app
without installing Elixir.

You build against the shared app (`docker-101/starter-app/starter_app`, generated in
setup). The Dockerfile lives here in `start/` — you'll build *against* the app
without copying anything into it.

## Steps

1. Open `start/Dockerfile` and fill in each `???` (a comment above each explains it):
   - the **base image** — match the Elixir/OTP you're pinned to in `docker-101/mise.toml`
   - the working directory and `MIX_ENV`
   - copy `mix.exs` + `mix.lock` and fetch/compile deps **before** the rest of the
     code, so layer caching works
   - build the release, and the `CMD` that starts it
2. Build the image, pointing Docker at the app:
   ```sh
   docker build -f start/Dockerfile -t starter-app:1.0 ../../starter-app/starter_app
   ```
   Two things worth understanding here:
   - **`-f start/Dockerfile`** tells Docker *which* Dockerfile to use. Without `-f`,
     Docker looks for a file literally named `Dockerfile` in the build context.
   - **The last argument (`../../starter-app/starter_app`) is the build *context*** —
     the directory Docker hands to the daemon and that every `COPY` reads from. By
     pointing it at the app, the `COPY` lines read *the app's* files, while the
     Dockerfile itself stays here in the exercise. No copying needed.

   Notice the Dockerfile copies the source **one directory at a time**
   (`COPY config config`, `COPY lib lib`, …) rather than `COPY . .`. That's
   deliberate: your app's `_build/` holds a release compiled for **your host OS**
   (you built one in the last exercise), and `COPY . .` would drag it into this
   Linux image, so the container dies with "Exec format error". Naming the dirs
   means only source ever crosses into the image.

## Check your work

From this exercise folder:

```sh
./validate
```
