# Alignment progress

Tracks which workshop sections have been reviewed and **aligned across all three
surfaces** (slide, web module, exercise) per `WORKSHOP-MODEL.md` and the recipe in
`AUTHORING.md`. Check a section off only when slide + module + exercise all agree.

## Docker 101

### Act 0
- [x] **Setup** (`00-set-up`) → `00-setup` requirements check

### Act 1 — Understanding containers
- [x] **What is Docker?** (`01-what-is-docker`, concept, no exercise)
- [x] **Run & manage containers** (`02-run-and-manage-containers`) → `act-1/01-run-and-manage-containers`
- [x] **Ports & networking** (part of `03-ports-networking-persistence`) → `act-1/02-ports-and-networking`
- [x] **Volumes & bind mounts** (part of `03-ports-networking-persistence`) → `act-1/03-volumes-and-bind-mounts`

### Act 2 — Packaging your app
- [ ] **OTP releases** → `act-2/01-otp-release` _(stub)_
- [ ] **Dockerfiles** (`04-dockerfiles`) → `act-2/02-first-dockerfile` _(stub)_
- [ ] **Build your first image** (`05-build-your-first-image`) → `act-2/03-build-the-image` _(stub)_

### Act 3 — Running in production
- [ ] **Multi-stage builds** (`06-multi-stage-builds`) → `act-3/01-multi-stage-build` _(stub)_
- [ ] **Registries** (`07-registries`) → `act-3/02-registries` _(stub)_
- [ ] **Docker Compose** (`08-docker-compose`) → `act-3/03-docker-compose` _(stub)_
- [ ] **Graceful shutdown** (`09-graceful-shutdown`, story/real-world)
- [ ] **Wrap-up** (`10-wrap-up`)

## Cross-cutting

- [ ] **Starter Phoenix app** (`docker-101/starter-app/`) — needed by the Act 2 & 3 exercises
- [ ] **De-duplicate** setup + exercise content (web module and repo README are
  currently kept in sync by hand; link or embed to make it single-source)

## Terraform 101

- [ ] Entire workshop (currently a placeholder; same three-surface model applies)
