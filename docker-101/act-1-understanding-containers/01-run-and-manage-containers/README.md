# Run & manage containers

**Goal:** get comfortable with the container lifecycle, the handful of commands
you'll use every day: `run`, `ps`, `logs`, `exec`, `stop`, `start`, `rm`.

No starter files for this one, you work entirely with the `docker` CLI.

## Steps

1. **Run a throwaway container** and drop into an Elixir shell inside it:
   ```
   docker run -it elixir iex
   ```
   Type `1 + 1` to prove it works, then `System.halt()` (or Ctrl-C twice) to exit.

2. **Run a long-lived container in the background**, named so we can find it:
   ```
   docker run -d --name workshop-shell elixir sleep infinity
   ```

3. **See it running:**
   ```
   docker ps
   ```

4. **Exec into the running container** (a new shell in the same container):
   ```
   docker exec -it workshop-shell iex
   ```
   Exit the shell, the container keeps running.

5. **Check its logs, stop it, start it again:**
   ```
   docker logs workshop-shell
   docker stop workshop-shell
   docker start workshop-shell
   ```

Leave `workshop-shell` **running** at the end, that's what the self-check looks
for.

## Check your work

```
./validate
```

## Clean up (after validating)

```
docker rm -f workshop-shell
```
