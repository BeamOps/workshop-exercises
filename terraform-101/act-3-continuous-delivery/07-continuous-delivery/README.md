# Ship it with CD

**Goal:** put your group's project under continuous delivery. Plan on every pull request, apply on
merge, no more applying from a laptop.

> **This is a group exercise.** As a group of four, pick **one** member's repo and state (their
> Act 2 `key`) and work together on **one laptop**. You'll set up the pipeline once, together.

Same project, **`terraform-101/github-project/main.tf`**, on top of module 06's remote state.

## A repo-scoped token first

CI needs a token to manage the repo. Do **not** reuse your broad Act 1 token, it can touch every
repo you own, and it'll end up in a shared repo's secrets. Instead create a **fine-grained PAT
scoped to just this one repo**:

- GitHub → Settings → Developer settings → Fine-grained tokens → Generate new token.
- **Repository access:** only your group's `beamops-workshop-app`.
- **Permissions:** Contents, Issues, Administration, and Secrets → **Read and write**; Metadata → Read.

Export it as your token for the rest of Act 3 (it replaces the Act 1 one):

```
export TF_VAR_github_token=github_pat_...
```

Now if this token ever leaks, the blast radius is one throwaway repo, not your account.

## What you'll do

1. **Feed the CI credentials as variables.** Add two sensitive variables, `aws_access_key_id` and
   `aws_secret_access_key`, and set them (plus your token) locally. Use a git-ignored
   `secrets.auto.tfvars`, or just `export TF_VAR_...`. Either works locally; **do not commit it.**
2. **Store them on the repo, with the module.** Add a `module "cd_secrets"` block sourcing
   `./modules/repo-secrets` (we ship it for you). Hand it the repo name and a map of the three
   secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `GH_TOKEN`.
3. `terraform init` (so Terraform picks up the module), then `terraform apply`. This **seeds the
   secrets** on the repo, you have to do this once locally, because CI can't set the secrets it
   needs to run.
4. **Push the project to the repo.** From `github-project/`: `git init`, commit (the `.gitignore`
   we ship keeps state and secrets out), add your `beamops-workshop-app` as the remote, and push.
5. **Add the pipeline.** Commit `.github/workflows/terraform-cd.yml` (see `solution/`) and push it.
   It runs `terraform plan` on PRs and `terraform apply` on merge to `main`.
6. **See it work.** Open a PR with a small change (rename the `workshop` label's colour). Watch the
   **plan appear as a comment**. Review it, merge, and watch the **apply** run.

## Check your work

```
./validate
```

It confirms your project uses the `repo-secrets` module, declares the AWS variables, and that the
CD workflow is present with a plan-on-PR / apply-on-merge shape, and that the config still
validates. The real proof is the plan comment landing on your PR.

## Heads up: secrets live in state

`github_actions_secret` (inside the module) stores each value in your Terraform **state**, so your
AWS keys and token now sit in the S3 state file. That's fine here, the bucket is private to your
group and torn down after the workshop, and the token is scoped to one repo. In production you'd
avoid it: use **OIDC** for cloud auth (no stored keys at all) and set any remaining secrets out of
band. Managing secrets with Terraform is convenient, but it's a real trade-off to know.

## Debrief

- Why does the first `apply` have to run locally, not in CI?
- Why a fine-grained, single-repo token instead of your Act 1 token?
- Where do the credentials come from when the pipeline runs, and why isn't `secrets.auto.tfvars`
  enough for CI?
