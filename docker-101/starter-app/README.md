# Starter app

A deliberately small Phoenix application used by the Act 2 and Act 3 exercises
(releases, Dockerfiles, multi-stage builds, Compose). Keeping one shared app
means attendees learn Docker, not a new codebase, at each step.

## Status

**TODO: generate the starter app.** It isn't committed yet, decisions to make
first:

- Phoenix version and generator flags. A likely fit:
  ```
  mix phx.new starter_app --no-mailer --no-dashboard
  ```
  Keep Ecto + Postgres (the Compose exercise needs a database) but trim anything
  that adds noise.
- One health/landing route that returns 200 so validators can check the app is
  actually serving (e.g. `GET /` or `/health`).
- Pin Elixir/OTP to match the workshop base image so releases build cleanly.

## How exercises use it

Each Act 2/3 exercise copies the relevant state into its own `start/` folder so
attendees always have a clean, known starting point. The `solution/` folders
hold the finished artifact (Dockerfile, compose.yaml, etc.).
