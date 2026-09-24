# Terraform 101 exercises

Work through these in order. Each exercise directory has a `README.md`, a `start/`
folder to work in, a `solution/` for reference, and a `./validate` self-check.

The exercises follow the three acts of the workshop. **Act 1 is available now**;
Acts 2 and 3 are on the way.

## Before you start

Confirm your machine is ready: work through [`00-setup`](00-setup/) and get a green
`./validate`. You'll need the Terraform CLI, a GitHub token, and the GitHub CLI.

## Act 1 — Infrastructure as code

| # | Exercise | Goal |
|---|----------|------|
| 01 | [first-resource](act-1-infrastructure-as-code/01-first-resource/) | Configure the GitHub provider and use `plan` to preview the repository and issues Terraform would create. |
| 02 | [milestone-and-branch-protection](act-1-infrastructure-as-code/02-milestone-and-branch-protection/) | Add a milestone and branch protection from the provider docs, then `apply` and `destroy` for real. |

## Act 2 — Reusable, stateful infrastructure

_Coming soon._ Variables, locals, `for_each`, and remote state.

## Act 3 — Secrets and automated delivery

_Coming soon._ SOPS-encrypted secrets and OIDC continuous deployment.

## A note on real resources

Unlike the Docker exercises (all local), these manage real GitHub repositories and
issues. Act 1's first exercise stops at `plan`, so nothing is created; the second
does a real `apply` and finishes with `destroy` to clean up. Never commit your
token — keep it in `TF_VAR_github_token` or a gitignored `terraform.tfvars`.
