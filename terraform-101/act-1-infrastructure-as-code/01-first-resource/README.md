# First resource: the GitHub provider

**Goal:** configure Terraform's GitHub provider and use `terraform plan` to preview
the repository and issues Terraform would create. This exercise stops at `plan` —
nothing is created on GitHub yet.

> _Draft scaffold — the full step-by-step lands in the next iteration._

## What you'll do

1. In `start/`, write `main.tf`:
   - a `terraform` block requiring the `integrations/github` provider (`~> 6.0`)
   - a `provider "github"` configured with a `github_token` variable
   - the `variable "github_token"` declaration (`sensitive = true`)
2. `terraform init` — download the provider and generate `.terraform.lock.hcl`.
3. Add a `github_repository` resource for your app repo.
4. Add a few issues with `for_each` over a `locals` map.
5. `terraform fmt`, `terraform validate`, then `terraform plan` — read the diff.

## Check your work

```
./validate
```

## Debrief

- Why commit `.terraform.lock.hcl`?
- What does `plan` show, and why always run it before `apply`?
- How does `for_each` differ from copy-pasting three resource blocks?
