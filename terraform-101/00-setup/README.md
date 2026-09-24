# Setup & environment check

Do this **before** the workshop, on good wifi. It gets your machine ready and
confirms everything works, so we don't lose the first hour to installs.

At the end, run `./validate` and get a green light.

## The quick path: mise

If you use [mise](https://mise.jdx.dev), this repo pins the tools for you. From the
`terraform-101/` directory:

```
mise install    # installs Terraform, gh, and the Act 3 secrets tools (sops, age)
```

That covers steps 1, 3, and 4 below — you still need a GitHub token (step 2). Prefer
to install things yourself? The per-OS instructions below work too.

## 1. Terraform

Install the Terraform CLI (1.6 or newer).

| OS | Install |
|----|---------|
| macOS | `brew tap hashicorp/tap && brew install hashicorp/tap/terraform` |
| Windows | `choco install terraform`, or download from [developer.hashicorp.com](https://developer.hashicorp.com/terraform/install) |
| Linux | [Package repo or binary](https://developer.hashicorp.com/terraform/install) |

Confirm it's on your PATH:

```
terraform version
```

## 2. A GitHub token

Act 1 uses Terraform's GitHub provider to manage real repositories and issues, so
you need a token Terraform can authenticate with.

1. Create a personal access token:
   - **Classic** ([github.com/settings/tokens](https://github.com/settings/tokens) → *Generate new token (classic)*): scope **`repo`**, plus **`delete_repo`** so you can clean up at the end.
   - **Fine-grained**: repo access to *All repositories*, with **Administration** and **Issues** set to read/write.
2. Export it so Terraform picks it up as the `github_token` variable:
   ```
   export TF_VAR_github_token="ghp_your_token_here"
   ```
   Re-export it in each new terminal (or add it to your shell profile for the day).
   **Never commit it.**

> We use `TF_VAR_github_token` — an environment variable Terraform automatically
> maps to the `github_token` input variable — so nothing secret lands in a file.
> The exercises also accept a gitignored `terraform.tfvars` if you prefer that.

## 3. GitHub CLI

The last Act 1 exercise does a real `apply` then `destroy` against GitHub, and its
check uses the GitHub CLI.

| OS | Install |
|----|---------|
| macOS | `brew install gh` |
| Windows | `choco install gh` |
| Linux | [cli.github.com](https://cli.github.com) |

## 4. Secrets tools: SOPS and age

You won't use these until **Act 3** (encrypting secrets), but install them now so
setup is one-and-done. `mise install` above already includes them.

| OS | Install |
|----|---------|
| macOS | `brew install sops age` |
| Windows | `choco install sops age` |
| Linux | [SOPS releases](https://github.com/getsops/sops/releases) + [age releases](https://github.com/FiloSottile/age/releases) |

## Check your work

```
cd terraform-101/00-setup
./validate
```

Green means you're ready for Terraform 101.

## Then see Terraform for yourself

The check gives you the green light. Run these yourself too, so the commands are
familiar before the workshop:

```
terraform version   # CLI version + any provider versions in the working dir
terraform -help     # the command surface you'll use all day
```
