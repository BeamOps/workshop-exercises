terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.2"
    }
  }
}

variable "github_token" {
  type        = string
  description = "GitHub personal access token"
  sensitive   = true
}

# No hardcoded token now: it comes from TF_VAR_github_token, so main.tf is safe to commit.
provider "github" {
  token = var.github_token
}

locals {
  issues = {
    "Move state to a shared backend" = "Terraform state should live in a remote backend, not on a laptop."
    "Encrypt the token with SOPS"    = "Stop passing the token by hand; commit it encrypted with SOPS and age."
    "Run terraform plan in CI"       = "Catch drift and review the plan on every pull request."
  }
}

resource "github_repository" "workshop_app" {
  name        = "beamops-workshop-app"
  description = "Built during BEAMOps Terraform 101"
  visibility  = "private"
  has_issues  = true
}

resource "github_repository_milestone" "roadmap" {
  owner      = split("/", github_repository.workshop_app.full_name)[0]
  repository = github_repository.workshop_app.name
  title      = "Workshop roadmap"
}

resource "github_issue" "issues" {
  for_each   = local.issues
  repository = github_repository.workshop_app.name
  title      = each.key
  body       = each.value
}

output "repo_url" {
  value = github_repository.workshop_app.html_url
}
