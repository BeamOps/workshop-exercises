# Providers, versions, and the lock file

**Goal:** see how Terraform resolves, pins, and upgrades provider versions, then run the
full `init → plan → apply → destroy` lifecycle with **no cloud account**. We use the
`random` provider: it needs no credentials, and `apply` produces a real value (a pet name)
in state.

## What you'll do

1. On the [Registry](https://registry.terraform.io/providers/hashicorp/random), find the
   `random` provider. In `start/main.tf`, add it to `required_providers` pinned to exactly
   `3.6.0`.
2. `terraform init` — Terraform downloads random 3.6.0 and records it in
   `.terraform.lock.hcl`. Open the lock file and find the version.
3. `terraform providers` — print the providers your configuration requires.
4. `terraform init -upgrade` — notice **nothing changes**: `-upgrade` only re-resolves
   within the constraints in your `terraform` block, and `3.6.0` is exact.
5. Loosen the constraint in `main.tf` to `~> 3.6` (allow any newer 3.x release).
6. `terraform init -upgrade` again — now Terraform resolves the newest matching version and
   rewrites `.terraform.lock.hcl`. Diff the lock file to see the version change.
7. Add a `random_pet` resource, and an `output` that exposes its name.
8. `terraform fmt`, then `terraform validate`.
9. `terraform plan` — preview the pet Terraform will create.
10. `terraform apply` — create it for real. The `output` prints your pet name. **No
    credentials needed.**
11. `terraform console` — poke at real state and HCL: try `random_pet.name.id`,
    `join("-", ["a", "b"])`, `upper("hcl")`.
12. `terraform plan` again — **"No changes"**: state matches config. That's idempotency.
13. `terraform destroy` — tear it down, closing the full lifecycle.

## Check your work

```
./validate
```

## Debrief

- What's the difference between the version *constraint* in `main.tf` (`~> 3.6`) and the
  *locked* version in `.terraform.lock.hcl`?
- Why did the first `terraform init -upgrade` change nothing?
- Why could you `apply` with no cloud credentials?
- After `apply`, why did a second `plan` say "No changes"?
