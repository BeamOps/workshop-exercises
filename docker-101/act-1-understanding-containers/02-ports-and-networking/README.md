# Ports & networking

**Goal:** publish a container's port so you can reach it from your browser, and
connect containers on a network so they reach each other by name.

We use `nginx` (as the app) and `postgres:18` (as the db). No starter files.

## Part 1 — Ports

1. Run nginx in the background, named `app`, publishing container port 80 to host port 4000:
   ```
   docker run -d --name app -p 4000:80 nginx
   ```
2. Open <http://localhost:4000> (or `curl localhost:4000`). You should see the nginx welcome page.
3. Run a second copy on a different host port, so both are reachable at once:
   ```
   docker run -d --name app-2 -p 4001:80 nginx
   ```
4. Confirm both respond: <http://localhost:4000> and <http://localhost:4001>.

## Part 2 — Networking

5. Create a user-defined network:
   ```
   docker network create app-net
   ```
6. Run Postgres on it, named `db` (no `-p` needed):
   ```
   docker run -d --name db --network app-net -e POSTGRES_PASSWORD=password postgres:18
   ```
7. From a throwaway container on the same network, reach `db` by name:
   ```
   docker run --rm --network app-net postgres:18 psql -h db -U postgres -c '\l'
   ```
   You should see the list of databases. No port was published, `db` resolved by name because both containers share `app-net`.

Leave `app`, `app-2`, and `db` running for the check.

## Check your work

```
./validate
```

## Clean up (after validating)

```
docker rm -f app app-2 db
docker network rm app-net
```
