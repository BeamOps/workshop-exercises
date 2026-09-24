# Multi-stage build

**Goal:** Convert your Dockerfile to a **multi-stage build** so the final image ships
only the release, not the whole Elixir/Erlang toolchain. Same app, a fraction of the
size.

Your Act 2 image (`starter-app:1.0`) is ~1.5 GB — it still has Mix, the compilers, and
your source in it. None of that is needed to *run* the release.

## Steps

1. Open `start/Dockerfile`. The **builder** stage is your Act 2 Dockerfile; fill in the
   `???`s for the multi-stage bits:
   - name the builder stage (`AS ???`)
   - a minimal **runner** base image with no Elixir/Mix (`FROM ???`)
   - copy **only** the compiled release from the builder (`COPY --from=??? ...`)
   - the `CMD` — in the runner the release lives at `/app`, so the server is at
     `/app/bin/server`
2. Build it with a new tag so you can compare:
   ```sh
   docker build -f start/Dockerfile -t starter-app:2.0 ../../starter-app/starter_app
   ```
3. Compare the sizes:
   ```sh
   docker images | grep starter-app
   ```
   The `2.0` (multi-stage) image should be a few hundred MB, versus ~1.5 GB for `1.0`.

## Check your work

```sh
./validate
```

## Debrief

- What does `COPY --from=builder` copy, and what gets left behind?
- Why is the runner image so much smaller?
- Why is a smaller image worth it in a CI/CD pipeline?
