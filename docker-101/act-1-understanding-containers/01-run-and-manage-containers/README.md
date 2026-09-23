# Run & manage containers

**Goal:** get comfortable with the container lifecycle, the handful of commands
you'll use every day: `run`, `ps`, `logs`, `exec`, `stop`, `start`, `rm`.

We'll use a Postgres container, a real, long-running service is a better lifecycle
example than a throwaway shell. No starter files, you work with the `docker` CLI.

## Steps

1. **Run Postgres in the background**, named so we can find it:
   ```
   docker run -d --name db -e POSTGRES_PASSWORD=postgres postgres:16
   ```

2. **See it running:**
   ```
   docker ps
   ```

3. **Check its logs** (you should see Postgres finish starting up):
   ```
   docker logs db
   ```

4. **Open a shell inside the running container**, then exit it (the container
   keeps running):
   ```
   docker exec -it db bash
   # ...poke around, then: exit
   ```

5. **Stop it, confirm it still exists, start it again:**
   ```
   docker stop db
   docker ps -a        # stopped containers still show here
   docker start db
   ```

Leave `db` **running** at the end, that's what the self-check looks for.

## Check your work

```
./validate
```

## Clean up (after validating)

```
docker rm -f db
```
