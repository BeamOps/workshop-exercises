# Docker 101 exercises

Work through these in order. Each exercise directory has a `README.md`, a
`start/` folder to work in, a `solution/` for reference, and a `./validate`
self-check.

The exercises follow the three acts of the workshop.

## Act 1 — Understanding containers

| # | Exercise | Goal |
|---|----------|------|
| 01 | [run-and-manage-containers](act-1-understanding-containers/01-run-and-manage-containers/) | Run your first container and learn the lifecycle: `run`, `ps`, `stop`, `start`, `rm`, `logs`, `exec`. |
| 02 | [ports-and-networking](act-1-understanding-containers/02-ports-and-networking/) | Publish a container port and reach a running app from your browser; run two containers on different host ports. |
| 03 | [volumes-and-bind-mounts](act-1-understanding-containers/03-volumes-and-bind-mounts/) | Bind-mount a local Phoenix project into a container and see a code change take effect without rebuilding. |

## Act 2 — Packaging your app

| # | Exercise | Goal |
|---|----------|------|
| 01 | [otp-release](act-2-packaging-your-app/01-otp-release/) | Build a production OTP release of the starter app with `mix release` and run the binary. |
| 02 | [first-dockerfile](act-2-packaging-your-app/02-first-dockerfile/) | Complete a partially-written Dockerfile for the starter Phoenix app. |
| 03 | [build-the-image](act-2-packaging-your-app/03-build-the-image/) | Build the image and run the app in a container on your machine. |

## Act 3 — Running in production

| # | Exercise | Goal |
|---|----------|------|
| 01 | [multi-stage-build](act-3-running-in-production/01-multi-stage-build/) | Convert the Dockerfile to a multi-stage build so the final image ships only the release, not the toolchain. |
| 02 | [registries](act-3-running-in-production/02-registries/) | Tag and push your image to a registry, then pull and run it. |
| 03 | [docker-compose](act-3-running-in-production/03-docker-compose/) | Wire the starter app and a Postgres database together with a Compose file. |

## The starter app

Acts 2 and 3 build and run a small Phoenix application. It lives in
[`starter-app/`](starter-app/) and each relevant exercise copies from it into its
`start/` folder. See its README for details.
