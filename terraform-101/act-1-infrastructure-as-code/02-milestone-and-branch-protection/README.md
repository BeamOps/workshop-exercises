# Milestone & branch protection (and a real apply)

**Goal:** using the [GitHub provider docs](https://registry.terraform.io/providers/integrations/github/latest/docs),
add two resources you haven't seen, then take the whole config through a real
`apply` and `destroy`.

> _Draft scaffold — the full step-by-step lands in the next iteration._

## What you'll do

1. Start from your `01-first-resource` config (or copy `solution/`).
2. Add a **milestone** with `github_repository_milestone`.
3. Link your issues to it — work out how to get the milestone's number onto
   `github_issue.milestone_number`.
4. Add **branch protection** on `main` with `github_branch_protection`, requiring
   at least one approving review before merge.
5. `terraform apply` — create it all on GitHub for real.
6. `terraform destroy` — watch Terraform remove everything in reverse dependency
   order.

## Check your work

```
./validate
```

The check uses the GitHub CLI (`gh`) to confirm the milestone and branch
protection exist after your `apply`.

## Debrief

- In what order did Terraform create the resources? Destroy them?
- How did you find the `milestone_number` wiring from the docs alone?
- What's the risk, and the benefit, of managing branch protection in code?
