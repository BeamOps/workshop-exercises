# Milestone & branch protection (a real apply)

**Goal:** using the [GitHub provider docs](https://registry.terraform.io/providers/integrations/github/latest/docs),
add two resources you haven't seen, then take the whole config through a real `apply`
and `destroy`.

Start from your `02-first-resource` config (it's copied into `start/` for you), with your
token exported.

## What you'll do

1. Add a **milestone** with `github_repository_milestone` on the repo.
2. Link your issues to it: set `milestone_number` on `github_issue`, working out how to read
   the number off the milestone resource.
3. Add **branch protection** on `main` with `github_branch_protection`, requiring one
   approving review (the nested `required_pull_request_reviews` block).
4. `terraform apply` to create it all on GitHub for real. Check the repo: the milestone, the
   issues on it, and a protected `main`.
5. `terraform destroy` to remove everything in reverse dependency order.

## Check your work

```
./validate
```

The check confirms your config declares the milestone, links the issues, and sets up branch
protection, and that it is valid. The real proof is seeing it on GitHub after `apply`.

## Debrief

- In what order did Terraform create the resources? Destroy them?
- How did you find the `milestone_number` wiring from the docs alone?
- What is the benefit, and the risk, of managing branch protection in code?
