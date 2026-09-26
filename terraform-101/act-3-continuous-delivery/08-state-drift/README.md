# Cause drift, watch CD catch it

**Goal:** see what happens when reality drifts from a plan someone already reviewed, and how the
pipeline refuses to apply a stale one.

> **This is a group drill.** Same one repo and one laptop as exercise 07, do this **together** so
> everyone watches the same pipeline run.

Builds on 07: your group's repo now has CD (plan on PR, apply on merge).

## Cause drift, watch CD fail

1. One person opens a PR that changes a resource, say the `workshop` label's **colour**, and gets
   the plan reviewed on the PR. **Don't merge yet.**
2. Another person **click-ops that same resource** in the GitHub UI: change the label's colour to
   something different, by hand.
3. Merge the PR. The **apply** job re-plans against reality first, sees the plan no longer matches
   the one that was approved, and **fails instead of applying**. That's the pipeline protecting you
   from shipping a change nobody reviewed.
4. **Recover together:** re-run the pipeline (or push a tiny commit for a fresh plan), read the new
   plan, decide whether to keep the manual change (fold it into config) or let Terraform revert it,
   review, and get a clean apply. The fix is never "click it back by hand", that just makes more
   drift.

> _Aside:_ in the real world you'd also catch drift proactively with a scheduled reconcile on
> non-production environments (see the slides). We're not setting one up here, just know it exists.

## Check your work

```
./validate
```

It confirms your CD pipeline is in place and your config validates after recovery. The real proof
is what you just watched: the apply **failing** on the drifted plan, then going green once you
re-planned.

## Debrief

- Why did the apply fail instead of applying the plan the reviewer approved?
- When drift happens, why is "click it back by hand" the wrong fix?
- How would you catch drift *before* it blocks someone's PR?
