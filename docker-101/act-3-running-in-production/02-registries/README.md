# Registries

**Goal:** Move an image through a registry — **tag → push → pull** — using a throwaway
**local registry** so you don't need any accounts.

You need the `starter-app:2.0` image from the multi-stage exercise.

## Steps

1. Run a local registry (it's just another container). We publish it on host port
   **5001** because macOS uses 5000 for AirPlay:
   ```sh
   docker run -d -p 5001:5000 --name registry registry:2
   ```
2. Tag your image with the registry's address, then push it:
   ```sh
   docker tag starter-app:2.0 localhost:5001/starter-app:2.0
   docker push localhost:5001/starter-app:2.0
   ```
   The registry address (`localhost:5001/`) at the front of the tag is what tells
   Docker *where* to push.
3. Prove it really lives in the registry: delete the local copies, then pull it back:
   ```sh
   docker rmi -f starter-app:2.0 localhost:5001/starter-app:2.0
   docker pull localhost:5001/starter-app:2.0
   ```
4. Confirm the pulled image works:
   ```sh
   docker run --rm localhost:5001/starter-app:2.0 bin/starter_app version
   ```

Leave the registry running and the pulled image present for the check.

## Check your work

```sh
./validate
```

## Clean up (after validating)

```sh
docker rm -f registry
docker rmi localhost:5001/starter-app:2.0
```
