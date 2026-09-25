# Providers and versions

**Goal:** set up the GitHub provider in your project and see how Terraform pins and upgrades
provider versions. No resources, no token: just `init` and the lock file.

You work in the shared **`terraform-101/github-project/`** directory for this and every GitHub
exercise, one project, built up step by step.

## What you'll do

In `terraform-101/github-project/main.tf`:

1. Add the `github` provider (`integrations/github`) pinned to exactly `6.2.0` in
   `required_providers`.
2. `terraform init`: downloads it and writes `.terraform.lock.hcl`. Find the version in the
   lock file.
3. `terraform providers`: print what your configuration requires.
4. `terraform init -upgrade`: notice nothing changes. `-upgrade` only re-resolves within your
   constraint, and `6.2.0` is exact.
5. Loosen the constraint to `~> 6.2`, then `terraform init -upgrade` again: the lock file
   updates to the newest 6.x.
6. `terraform fmt`, then `terraform validate`.

Downloading a provider needs no token. In the next exercise you add a repository to this same
project.

## Check your work

```
./validate
```

The check looks at your `github-project/`, so run it from anywhere in the repo.

## Debrief

- The version *constraint* (`~> 6.2`) vs the *locked* version in `.terraform.lock.hcl`?
- Why did the first `terraform init -upgrade` change nothing?
