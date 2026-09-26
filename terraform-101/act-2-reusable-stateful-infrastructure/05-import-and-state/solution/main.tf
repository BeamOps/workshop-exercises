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

provider "github" {
  token = var.github_token
}

locals {
  issues = {
    "Move state to a shared backend" = "Terraform state should live in a remote backend, not on a laptop."
    "Add a CD pipeline"              = "Plan on every PR, apply on merge, so nobody applies from a laptop."
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

# You created this label by hand on GitHub (ClickOps), then adopted it with an import
# block. The block is a one-time migration; delete it once the apply succeeds:
#
#   import {
#     to = github_issue_label.workshop
#     id = "your-org/beamops-workshop-app:workshop"
#   }
resource "github_issue_label" "workshop" {
  repository = github_repository.workshop_app.name
  name       = "workshop"
  color      = "5319e7"
}

output "repo_url" {
  value = github_repository.workshop_app.html_url
}
