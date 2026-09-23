# Workshop authoring guide (for a Claude session)

Hand this file to a Claude session to revise or add a workshop **section**, keeping
the three surfaces aligned. For the human-facing concept, see `WORKSHOP-MODEL.md`
in the `BeamOps/workshop-exercises` repo.

## The three surfaces and where they live

| Surface | Location | What it is |
|---|---|---|
| **Web module** | `beamops` → `priv/workshops/<workshop>/NN-name.md` | Teaching content (NimblePublisher, compiled at build time) |
| **Slides** | `beamops` → `lib/beamops/workshops/slides.ex` | The presentation deck (`present` LiveView) |
| **Exercise** | `BeamOps/workshop-exercises` → `<workshop>/<act>/NN-name/` | Hands-on + `./validate` self-check |

A section is either **concept** (content + slides, no exercise) or **hands-on**
(content + slides ending in a "Your turn" card + an exercise folder).

## Web module (`priv/workshops/<workshop>/NN-name.md`)

Frontmatter, then markdown body:

```elixir
%{
  title: "What is Docker?",
  description: "...",        # SEO / overview
  duration: "15 min",
  format: "concept",         # or "demo + hands-on", etc.
  act: 1                     # 0 = setup; 1/2/3 = acts
}
---
<body>
```

- The module page renders an `Act N · <act name>` breadcrumb from `act` + the
  workshop's `act_labels` (act 0 has no label, so no breadcrumb).
- For a hands-on section, the body's `## Exercise` section currently mirrors the
  repo README steps (we maintain both in sync, see "Source of truth") + a
  `## Debrief`.
- Filenames are `NN-slug.md`; the `id` used in routes/slides is the slug (e.g.
  `what-is-docker`).

## Slides (`lib/beamops/workshops/slides.ex`)

Each workshop is a list of slide maps under `defp <workshop>()`. Slide `type`s:
`:intro`, `:act`, `:setup`, `:concept`, `:comparison`, `:code`, `:exercise`,
`:story`, `:recap`, `:break`.

- **Content slides** (`:concept`, `:comparison`, `:code`, ...) carry `act:` (int)
  and `section:` (string = the module title) so they render the
  `Act N · Section` breadcrumb.
- **Act divider**: `type: :act, act: N, title: "<act name>", subtitle: ...`.
- **"Your turn" card**: `type: :exercise` with `title`, `goal`, `duration`,
  `folder` (path into the exercises repo), and `code` (the `cat README.md` +
  `./validate` snippet). **No step list on the card**, steps live in the exercise
  README.
- `act_labels` (the `{"Act N", "<name>"}` map) lives per-workshop in
  `lib/beamops/workshops/workshops.ex`.
- Preview at `/workshops/<slug>/present` (`?s=N` jumps to a slide).

## Exercise (`workshop-exercises/<workshop>/<act>/NN-name/`)

```
NN-name/
  README.md    # Goal, Steps, Check your work, Debrief
  start/       # starting state (may be empty)
  solution/    # reference solution
  validate     # executable self-check
```

`validate` sources `bin/lib.sh`. Helpers include: `require_docker`, `check_msg
"desc" "hint" <cmd>`, `finish`, and outcome checks: `container_running`,
`container_publishes <name> <host-port>`, `container_did <name> <action>` (reads
`docker events`), `image_exists`, `http_ok`, `volume_exists`, `network_exists`,
`network_has_container`, `can_reach <network> <name>` (ping by name),
`pg_has_db`, `pg_has_value <container> <sql> <expected>`.

Validator philosophy:
- **Check real outcomes / events, not trust.** Prefer end-state checks and
  `container_did` (created/stopped/exec/destroy) over believing the learner.
- **Check the exercise's OWN resources, not ambient state.** A loose check
  false-passes on leftovers or unrelated processes. Don't `http_ok
  localhost:4000` (a stray Phoenix dev server on the port passes it), check the
  exercise's container publishes the port (`container_publishes app 4000`).
  Don't check "a container named `db` is running" (a `db` left over from a
  previous exercise passes it), check something *this* exercise produced (its
  named volume, or a row it wrote via `pg_has_value`).
- **Hints nudge, they don't give the command.** Say *what* is missing
  ("`db` was never stopped"), never *how* (`docker stop db`). (Setup is the
  exception, it's a prerequisites checklist, so its hints may give commands.)
- **All steps run from the host** (`docker run …`, `docker exec db psql -c "…"`),
  never inside an interactive shell, so `validate` (also on the host) can observe
  their effects.
- Exercises can end however the lifecycle dictates (e.g. removing the container),
  `container_did` reads the event log so checks work even after `docker rm`.

State & cleanup:
- Exercises reuse names across sections (`app`, `db`), so leftover state pollutes
  the next one. `bin/reset` removes the Docker 101 containers/networks/volumes.
  Add a "**Start clean:** run the repo's `bin/reset`" note near the top of any
  exercise that could inherit state, and extend `bin/reset` when you introduce
  new names.
- Exercises leave the resource the validator checks **running** (cleanup is a
  separate "after validating" step). Combined with specific checks (above), a
  resource left running by a prior exercise then won't cause a false pass.

## Alignment rules

- Every content slide **and** module page shows the `Act N · Section` breadcrumb.
- Every hands-on section ends with a **"Your turn"** card → its exercise `folder`
  + `duration`.
- Use consistent, current values: **`postgres:18`** (latest pinned major), real
  image names (`elixir`, not placeholders), one container name per exercise
  (e.g. `db`).
- Order lifecycle steps so commands run against a valid state (e.g. `exec` only
  on a **running** container; put the shell step after `start`, `rm` last).

## Source of truth (current state)

Goal: each piece of content lives once (steps in the repo README; teaching in the
module). **Right now we deliberately keep two copies in sync by hand** for the
setup instructions and the exercise steps/debrief (web module + repo README).
When you edit one, edit the other. This is a temporary simplification to
de-duplicate later (link or embed the repo README from the site).

## Workflow / commands

beamops (run from the repo/worktree root):
```
mix compile --warnings-as-errors
mix format            # + mix format --check-formatted
mix credo --strict
mix phx.server        # dev server; slides.ex and priv/workshops/*.md hot-reload
```
exercises repo:
```
chmod +x <exercise>/validate      # after creating/rewriting one
./validate                        # test by doing the exercise, then running it
```

## Recipe: add or revise a hands-on section

1. **Module**: write/adjust `priv/workshops/<workshop>/NN-slug.md` (frontmatter
   `act:` set correctly).
2. **Slides**: in `slides.ex`, add/adjust the concept slide(s) with `act:` +
   `section:`, then an `:exercise` "Your turn" card with `folder:` + `duration:`.
   Tag any new content slide with the breadcrumb.
3. **Exercise**: create `workshop-exercises/<workshop>/<act>/NN-slug/` with
   `README.md`, `start/`, `solution/`, `validate` (using `bin/lib.sh`).
4. **Sync**: keep the module's `## Exercise` section and the repo README in step
   (see Source of truth).
5. **Verify**: `mix compile` + `mix format` + `mix credo`; open present mode and
   the module page; do the exercise and confirm `./validate` goes green.

## Gotchas already fixed (don't reintroduce)

- `present.ex` `highlight_code_line/1`: a `$` command line with **no trailing
  comment** must still parse (use the list-tail / `List.first(rest, "")` form).
- `validate` + `docker events`: **capture output then grep a here-string**
  (piping into `grep -q` + `pipefail` reports SIGPIPE as a failed match). Use a
  **daemon-relative** window (`--since 1h --until 0s`), not the host clock,
  Docker Desktop's VM clock can drift.
- `exec` only works on a **running** container, order steps accordingly.
