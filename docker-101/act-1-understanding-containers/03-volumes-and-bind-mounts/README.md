# Volumes & bind mounts

**Goal:** see that a container's data *doesn't* survive being removed, then make
it survive with a volume.

We use `postgres:17`. (Postgres 18 moved where it stores its data, changing the
mount path; we stick with 17 here for the classic layout.) No starter files.

> **Start clean:** if you did an earlier exercise, run the repo's `bin/reset`
> first to clear leftover containers and volumes.

## First, see the problem (no volume)

1. Run Postgres with no volume:
   ```
   docker run -d --name db -e POSTGRES_PASSWORD=password postgres:17
   ```
2. Create a table with a row:
   ```
   docker exec db psql -U postgres -c "CREATE TABLE notes (msg text); INSERT INTO notes VALUES ('it survived');"
   ```
3. Remove the container and start a fresh one:
   ```
   docker rm -f db
   docker run -d --name db -e POSTGRES_PASSWORD=password postgres:17
   ```
4. Look for your table, it's **gone** (`ERROR: relation "notes" does not exist`):
   ```
   docker exec db psql -U postgres -c "SELECT * FROM notes;"
   ```
5. Run `./validate`, it confirms there's no persistence yet, and points you to the next step.

## Now make it survive (named volume)

6. Remove the no-volume container and run Postgres with a named volume `db-data`, then recreate the table:
   ```
   docker rm -f db
   docker run -d --name db -e POSTGRES_PASSWORD=password -v db-data:/var/lib/postgresql/data postgres:17
   docker exec db psql -U postgres -c "CREATE TABLE notes (msg text); INSERT INTO notes VALUES ('it survived');"
   ```
7. Remove the container and start a new one with the **same** volume, the row is still there:
   ```
   docker rm -f db
   docker run -d --name db -e POSTGRES_PASSWORD=password -v db-data:/var/lib/postgresql/data postgres:17
   docker exec db psql -U postgres -c "SELECT * FROM notes;"
   ```
   The data lives in the `db-data` volume, not the container.

## Bind mount — data on your own filesystem

A bind mount does the same job, but **you** choose the host location.

8. Run a second Postgres with a bind mount to a local `pgdata` folder:
   ```
   docker run -d --name db2 -e POSTGRES_PASSWORD=password -v ./pgdata:/var/lib/postgresql/data postgres:17
   ```
9. Look inside `./pgdata` — Postgres's data files are right there on your machine:
   ```
   ls pgdata
   ```

Leave both `db` and `db2` running.

## Check your work

```
./validate
```

## Clean up (after validating)

```
docker rm -f db db2
docker volume rm db-data
rm -rf pgdata
```
