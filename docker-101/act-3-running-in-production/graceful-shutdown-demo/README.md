# Demo: Oban graceful shutdown

**Presenter demo, not an attendee exercise.** It shows a running Oban job either
draining cleanly or getting killed mid-flight when the container is asked to stop —
decided purely by the queue's `shutdown_grace_period`. This is the war story from
module 09, live.

It reuses the Compose stack from `03-docker-compose` (Oban needs Postgres). We send
**SIGTERM directly** (`docker compose kill -s SIGTERM app`) rather than `docker stop`,
so there's no Docker stop-timeout in play — the container stays up until *Oban itself*
decides to exit, so the outcome depends only on the grace period.

## 1. Add Oban to the starter app

Run the setup script — it wires Oban into the starter app for you (idempotent, safe to
re-run):

```sh
./setup.sh
```

It adds the `oban` dep, the `oban_jobs` migration, the `SlowJob` worker, the Oban config
(with an `OBAN_GRACE`-tunable `shutdown_grace_period`), and Oban in the supervision tree,
then runs `mix compile`. If any step can't find where to insert (a non-standard app), it
tells you exactly what to add by hand.

## 2. Rebuild the image and start the stack

```sh
docker build -f ../01-multi-stage-build/start/Dockerfile -t starter-app:3.0 ../../starter-app/starter_app
docker compose up -d          # from this demo folder; migrate runs the Oban migration too
docker compose logs -f app    # in another terminal, to watch the job
```

## 3. Case A — grace period too short (job killed)

Recreate the app with a 5s grace, enqueue a 20s job, then SIGTERM it:

```sh
OBAN_GRACE=5000 docker compose up -d --force-recreate app
docker compose exec app bin/starter_app rpc 'StarterApp.Workers.SlowJob.new(%{seconds: 20}) |> Oban.insert()'
# wait a few seconds so the job is mid-flight, then:
docker compose kill -s SIGTERM app
```

Oban waits its 5s grace, the 20s job is still running, so Oban kills it and the app
exits. In the logs you'll see the `⏳ working…` ticks **stop around `5/20s` with no
`✅ COMPLETED` line**:

```sh
docker compose exec db psql -U postgres -d starter_app \
  -c "SELECT id, state, worker FROM oban_jobs ORDER BY id DESC LIMIT 3;"
```

## 4. Case B — grace period long enough (job drains)

Same thing, but give Oban 30s:

```sh
OBAN_GRACE=30000 docker compose up -d --force-recreate app
docker compose exec app bin/starter_app rpc 'StarterApp.Workers.SlowJob.new(%{seconds: 20}) |> Oban.insert()'
docker compose kill -s SIGTERM app
```

This time Oban waits, the ticks run **all the way to `✅ SlowJob #N COMPLETED`**, the job's
state is **`completed`**, and the app then exits cleanly.

## The point

- Oban's `shutdown_grace_period` must cover your longest job, or jobs get killed and retried.
- In the real world there's a second clock: Docker's stop timeout (`docker stop -t`, or
  Compose `stop_grace_period`) must be **larger than** the grace period, or Docker sends
  SIGKILL before Oban finishes draining. The rule from the story:
  **`stopTimeout > shutdown_grace_period > longest job`**.

## Clean up

```sh
docker compose down -v
```
