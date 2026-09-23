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
4. Look for your table, it's **gone**:
   ```
   docker exec db psql -U postgres -c "SELECT * FROM notes;"
   ```
   You'll get `ERROR: relation "notes" does not exist`. The data died with the container.
5. Clean up: `docker rm -f db`

## Now make it survive (named volume)

6. Run Postgres with a named volume `db-data`:
   ```
   docker run -d --name db -e POSTGRES_PASSWORD=password -v db-data:/var/lib/postgresql/data postgres:17
   ```
7. Create the table again:
   ```
   docker exec db psql -U postgres -c "CREATE TABLE notes (msg text); INSERT INTO notes VALUES ('it survived');"
   ```
8. Remove the container and start a new one with the **same** volume:
   ```
   docker rm -f db
   docker run -d --name db -e POSTGRES_PASSWORD=password -v db-data:/var/lib/postgresql/data postgres:17
   ```
9. This time the row is still there:
   ```
   docker exec db psql -U postgres -c "SELECT * FROM notes;"
   ```
   The data lives in the `db-data` volume, not the container.

## Bind mount — data on your own filesystem

10. (Optional) Run Postgres with a bind mount to a local folder instead:
    ```
    docker run -d --name db2 -e POSTGRES_PASSWORD=password -v ./pgdata:/var/lib/postgresql/data postgres:17
    ```
    Look inside `./pgdata` — Postgres's data files are right there on your machine. With a bind mount **you** pick the host path; with a named volume Docker owns it.

Leave the named-volume `db` running for the check.

## Check your work

```
./validate
```

## Clean up (after validating)

```
docker rm -f db db2
docker volume rm db-data
```
