# Terraform 101 exercises

Work through these in order. Each exercise directory has a `README.md`, a `start/`
folder to work in, a `solution/` for reference, and a `./validate` self-check.

The exercises follow the three acts of the workshop, all available below.

## Before you start

Confirm your machine is ready: work through [`00-setup`](00-setup/) and get a green
`./validate`. You'll need the Terraform CLI, a GitHub token, and the GitHub CLI.

## Act 1 — Infrastructure as code

| # | Exercise | Goal |
|---|----------|------|
| 01 | [providers-and-the-workflow](act-1-infrastructure-as-code/01-providers-and-the-workflow/) | Explore the provider registry and the core workflow (init, fmt, validate, plan, console), no credentials needed. |
| 02 | [first-resource](act-1-infrastructure-as-code/02-first-resource/) | Configure the GitHub provider and use `plan` to preview the repository and issues Terraform would create. |
| 03 | [milestone](act-1-infrastructure-as-code/03-milestone/) | Add a milestone that references the repo (an implicit dependency) from the provider docs, then `apply` and `destroy` for real. |

## Act 2 — Reusable, stateful infrastructure

| # | Exercise | Goal |
|---|----------|------|
| 04 | [variables-and-for-each](act-2-reusable-stateful-infrastructure/04-variables-and-for-each/) | Move the token into a variable and create your issues with `for_each`. |
| 05 | [import-and-state](act-2-reusable-stateful-infrastructure/05-import-and-state/) | Import a hand-made label and inspect state with the state commands and console. |
| 06 | [remote-state](act-2-reusable-stateful-infrastructure/06-remote-state/) | Move your state to a shared S3 backend with locking. |

## Act 3 — Continuous delivery

| # | Exercise | Goal |
|---|----------|------|
| 07 | [continuous-delivery](act-3-continuous-delivery/07-continuous-delivery/) | Put your group's repo under CD: secrets via a module, plan on PR, apply on merge. |
| 08 | [state-drift](act-3-continuous-delivery/08-state-drift/) | Cause drift and watch the pipeline refuse a stale plan, then recover as a group. |

## A note on real resources

Unlike the Docker exercises (all local), these manage real GitHub repositories and
issues. Act 1's first exercise stops at `plan`, so nothing is created; the second
does a real `apply` and finishes with `destroy` to clean up. Never commit your
token — keep it in `TF_VAR_github_token` or a gitignored `terraform.tfvars`.
