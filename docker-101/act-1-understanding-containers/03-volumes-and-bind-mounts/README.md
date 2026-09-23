# Volumes & bind mounts

**Goal:** make a database's data survive its container being removed (named
volume), and see the same data on your own filesystem (bind mount).

We use `postgres:17`. No starter files.

## Named volume — data survives removal

1. Run Postgres with a named volume `db-data`:
   ```
   docker run -d --name db -e POSTGRES_PASSWORD=password -v db-data:/var/lib/postgresql/data postgres:17
   ```
2. Create a database, so there's something to lose:
   ```
   docker exec db createdb -U postgres persisted
   ```
3. Remove the container entirely:
   ```
   docker rm -f db
   ```
4. Start a new container using the **same** volume:
   ```
   docker run -d --name db -e POSTGRES_PASSWORD=password -v db-data:/var/lib/postgresql/data postgres:17
   ```
5. Confirm your `persisted` database is still there:
   ```
   docker exec db psql -U postgres -c '\l'
   ```
   The data survived because it lives in the `db-data` volume, not the container.

## Bind mount — data on your own filesystem

6. (Optional) Run Postgres with a bind mount to a local folder instead:
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
