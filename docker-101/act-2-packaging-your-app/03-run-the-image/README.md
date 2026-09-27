# Run your image

**Goal:** Run the image you built as a container — reach it in your browser, then get
inside it and attach a live console to the running app.

You need the `starter-app:1.0` image from the previous exercise.

## Steps

1. Run the container, publishing the port and passing the runtime config the release
   reads at startup:
   ```sh
   docker run -d --name starter -p 4000:4000 \
     -e SECRET_KEY_BASE="$(openssl rand -base64 48)" \
     -e DATABASE_URL="ecto://postgres:postgres@localhost/starter_app" \
     -e PHX_SERVER=true \
     starter-app:1.0
   ```
   Open <http://localhost:4000> — it's serving straight from your image.

   There's no database yet, so `docker logs starter` shows Postgres connection
   warnings. That's expected; Act 3 wires up a real database with Compose. The
   landing page doesn't need it.
2. Get a shell inside the running container and find the release:
   ```sh
   docker exec -it starter bash
   ls _build/prod/rel/starter_app      # the release: bin/server, bin/starter_app
   exit
   ```
3. Attach a live console to the running app and run some Elixir. Use the release
   binary's full path (`docker exec` runs from the image's `WORKDIR`, `/app`, not
   the release directory):
   ```sh
   docker exec -it starter /app/_build/prod/rel/starter_app/bin/starter_app remote
   ```
   Try `Application.started_applications()` or `1 + 1`, then press Ctrl+C twice to
   detach — this leaves the container running.

Leave the `starter` container running for the check.

## Check your work

```sh
./validate
```

## Clean up (after validating)

```sh
docker rm -f starter
```
