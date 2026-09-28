# Cause drift, watch CD catch it

**Goal:** see what happens when reality drifts from a plan someone already reviewed, and how the
pipeline refuses to apply a stale one.

## Cause drift, watch CD fail

1. Open a PR that changes a resource (say, a label's colour), and gets its plan reviewed, **don't merge it yet**.
2. **Click-ops that same resource** directly in the GitHub UI (change the colour to something else).
3. Merge the PR. The apply job **re-plans, sees the drift, and fails** as the approved plan no longer matches reality.

## Debrief

- Why did the apply fail instead of applying the plan the reviewer approved?
- When drift happens, why is "click it back by hand" the wrong fix?
- How would you catch drift *before* it blocks someone's PR?
