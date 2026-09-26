# `repo-secrets` module

A tiny local module that sets one or more **GitHub Actions secrets** on a
repository. We wrote it so you can see what a module is: a folder of Terraform
with its own `variables` (inputs) that you call from your config with `source`.

## Inputs

| Name | Type | Description |
|------|------|-------------|
| `repository` | `string` | Repo to set the secrets on |
| `secrets` | `map(string)` (sensitive) | `name => value` for each secret |

## Usage

```hcl
module "cd_secrets" {
  source     = "./modules/repo-secrets"
  repository = github_repository.workshop_app.name
  secrets = {
    AWS_ACCESS_KEY_ID     = var.aws_access_key_id
    AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
    GH_TOKEN              = var.github_token
  }
}
```

Internally it's just a `github_actions_secret` with `for_each = var.secrets`, the
same `for_each` from Act 2, packaged so it's reusable on any repo. After adding
or changing a module block, run `terraform init` so Terraform picks the module up.
