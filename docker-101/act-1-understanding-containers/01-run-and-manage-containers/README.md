# Run & manage containers

**Goal:** work through the full container lifecycle, the handful of commands
you'll use every day: `run`, `ps`, `logs`, `exec`, `stop`, `start`, `rm`.

We use a Postgres container. No starter files, you work with the `docker` CLI.

## Steps

1. Run a Postgres container called `db` in the background with `POSTGRES_PASSWORD=password`:
   ```
   docker run -d --name db -e POSTGRES_PASSWORD=password postgres:17
   ```
2. Confirm it's running with `docker ps`
3. View its logs with `docker logs db`
4. Stop the container, then confirm it's stopped but still exists with `docker ps -a`:
   ```
   docker stop db
   docker ps -a
   ```
5. Start it again with `docker start db`
6. Now that it's running again, open a bash shell inside it and try `psql -U postgres` and `\l` to list databases (you can only `exec` into a *running* container):
   ```
   docker exec -it db bash
   # inside the container: psql -U postgres   then  \l   then  \q
   ```
7. Exit the shell
8. Remove it with `docker rm -f db`

## Check your work

```
./validate
```

The check reads Docker's event log to confirm you actually ran through the
lifecycle, created the container, stopped it, opened a shell, and removed it, so
it's fine (expected, in fact) that nothing is left running at the end.

## Debrief

- What's the difference between an image and a container?
- What happens to data inside a container when you stop it?
- What happens when you remove it?
- If you run `postgres:17` twice, do you get two separate databases?
