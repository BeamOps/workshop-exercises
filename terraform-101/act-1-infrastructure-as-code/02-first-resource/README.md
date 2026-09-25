# First resource: the GitHub provider

**Goal:** configure the GitHub provider, create a repository, and add issues with
`for_each`, then `plan` it. We **stop at plan** here (nothing is created); the next
exercise applies it for real.

Export the token you made in setup first:

```
export TF_VAR_github_token="ghp_your_token_here"
```

## What you'll do

In `start/`:

1. Write `main.tf`: the `terraform` block requiring `integrations/github` (`~> 6.0`), a
   `provider "github"` using a `github_token` variable, and the `variable "github_token"`
   (`sensitive = true`).
2. `terraform init` to download the provider and write `.terraform.lock.hcl`.
3. Add a `github_repository` resource for your app (private, `has_issues = true`).
4. Add a few issues with `for_each` over a `locals` map (the workshop roadmap: pin
   providers, remote state, SOPS secrets).
5. `terraform fmt`, `terraform validate`, then `terraform plan` and read the diff. **Stop
   at plan.** The next exercise applies it.

## Check your work

```
./validate
```

## Debrief

- Why commit `.terraform.lock.hcl`?
- What does `plan` show, and why always run it before `apply`?
- How does `for_each` differ from three copy-pasted resource blocks?
