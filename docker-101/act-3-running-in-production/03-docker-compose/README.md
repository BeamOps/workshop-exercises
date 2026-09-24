# Docker Compose

**Goal:** Wire the Phoenix app to Postgres with a `compose.yaml` so `docker compose up`
brings up the whole stack — **database → migrations → app** — in the right order. This
is where the "no database yet" from Act 2 finally gets resolved.

**Prerequisite:** you need the `starter-app:2.0` image from the multi-stage exercise. If
you removed it (the registries exercise does), rebuild it:
```sh
docker build -f ../01-multi-stage-build/start/Dockerfile -t starter-app:2.0 ../../starter-app/starter_app
```

## Steps

1. Open `start/compose.yaml` and fill in each `???` (the `pg_isready` healthcheck and
   the two `depends_on` conditions are already filled in for you — that's the ordering
   the slides covered):
   - the Postgres image
   - `DATABASE_URL` pointing at the **`db` service by name** (not `localhost`)
   - the published port, and the volume mount path
2. Bring the stack up from the `start/` folder:
   ```sh
   cd start
   docker compose up
   ```
   Watch the order: `db` becomes healthy → `migrate` runs and exits → `app` starts.
3. In another terminal, verify:
   - `docker compose ps` — `db` and `app` are up
   - <http://localhost:4000> — the app serves
   - `docker compose logs migrate` — the migrate step ran and exited

Leave the stack running for the check.

## Check your work

From this exercise folder:
```sh
./validate
```

## Clean up (after validating)

```sh
cd start && docker compose down -v   # -v also removes the db-data volume
```

## Debrief

- How does the app reach the database at `db` instead of `localhost`?
- What do the two `depends_on` conditions guarantee about start order?
- What does the named volume give you across `docker compose down` / `up`?
