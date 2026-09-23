# Ports & networking

**Goal:** publish a container's port so you can reach it from your browser, and
connect containers on a network so they reach each other by name.

We use `nginx` (as the app), `postgres:18` (as the db), and `busybox` (a tiny
image with a `ping` tool). No starter files.

> **Start clean:** if you did an earlier exercise, run the repo's `bin/reset`
> first to clear leftover containers and networks.

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

Containers only resolve each other by name on a **user-defined** network. Let's prove it.

5. Run Postgres named `db` on the default network for now:
   ```
   docker run -d --name db -e POSTGRES_PASSWORD=password postgres:18
   ```
6. Try to reach it by name from another container. This **fails** with `bad address 'db'`, the default network gives no name resolution:
   ```
   docker run --rm busybox ping -c1 db
   ```
7. Create a user-defined network and reconnect `db` to it:
   ```
   docker rm -f db
   docker network create app-net
   docker run -d --name db --network app-net -e POSTGRES_PASSWORD=password postgres:18
   ```
8. Ping `db` by name from a container on the same network. Now it **works**:
   ```
   docker run --rm --network app-net busybox ping -c1 db
   ```

Leave `app`, `app-2`, and `db` running for the check.

## Check your work

```
./validate
```

## Clean up (after validating)

Run the repo's `bin/reset`, it removes this exercise's containers and the `app-net` network (the next section's "Start clean" runs it too).
