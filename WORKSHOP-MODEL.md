# How the workshop fits together

Each workshop has **three surfaces**, and this doc is how we keep them aligned.

| Surface | Lives in | Purpose |
|---|---|---|
| **Web module** | `beamops` → `priv/workshops/<workshop>/NN-*.md` | The reading/teaching content |
| **Slides** | `beamops` → `lib/beamops/workshops/slides.ex` | The presentation deck |
| **Exercise** | this repo → `<workshop>/<act>/NN-name/` | Hands-on + a self-check |

## The rhythm of a section

A hands-on section plays out like this:

```
[slides]   Act divider → concept/demo slides → "Your turn" card
                              │                       │
                              │ breadcrumb:           │ points to →
                              │ "Act 1 · Ports"       ▼
[repo]                                    <act>/NN-name/  (README + validate)
[web]      module teaches the concepts, then points to that same folder
```

1. You **present** the concept/demo slides (each shows an `Act · Section` breadcrumb so the room always knows where they are).
2. You hit the **"Your turn" card** — it names the exercise folder and a time-box. That's the single "stop talking, go do it" signal.
3. Attendees open the folder, follow the **README**, and run **`./validate`**.
4. The room goes green at its own pace; you move to the next section.

## Concept vs hands-on sections

- **Concept** (e.g. "What is Docker?"): content + slides, **no** exercise, **no** "your turn".
- **Hands-on** (e.g. "Run & manage containers"): content + slides + a **"your turn"** card + an exercise folder.

## What keeps the three aligned

- **Breadcrumbs** — every content slide carries `Act N · Section`, matching the module title.
- **"Your turn" cards** — every hands-on section ends with one; it carries the `folder` and `duration`.
- **One exercise = one folder** — `<workshop>/<act>/NN-name/` with `README.md` + `start/` + `solution/` + `validate`.
- **Validators check real work** — `./validate` verifies container state *and* reads Docker's event log to confirm the lifecycle actually happened (works even after `docker rm`). Plain shell, OS-agnostic, no language toolchain required.

## Source of truth

Goal: each piece of content lives **once**.
- Exercise **steps** → the repo README (attendees are in the terminal; the "your turn" card says `cat README.md`).
- **Teaching** → the web module.
- The slide + module **link** to the exercise folder rather than copying the steps.

**Known simplification (temporary):** right now we deliberately keep a couple of
duplicates in sync by hand, setup instructions appear on the web page *and* in
`00-setup/README.md`, and the debrief questions appear in both. That's on purpose
for speed; we'll de-duplicate once the content settles (likely: link the web
module to the repo README, or embed it via submodule).

## Worked example: Docker 101, Act 1

- `00-setup` — requirements self-check (Docker, images, Elixir via mise) ✅
- `01-run-and-manage-containers` — full lifecycle, events-based validate ✅ (the reference to copy)
- `02-ports-and-networking`, `03-volumes-and-bind-mounts` — stubs, to be written

## Recipe: adding a hands-on section

1. **Module** — write the teaching content in `beamops/priv/workshops/...`.
2. **Slides** (`slides.ex`) — add concept slide(s) with `act:` + `section:`, then an
   `:exercise` "your turn" card with `folder:` + `duration:`.
3. **Exercise** — create `<workshop>/<act>/NN-name/` here: `README.md` (steps),
   `start/`, `solution/`, and a `validate` script.
4. **validate** — use the `bin/lib.sh` helpers: `require_docker`, `check_msg`,
   `container_did`, `image_exists`, `http_ok`, `finish`. Prefer checks that verify
   real end state or real actions (events) over trusting the learner.
