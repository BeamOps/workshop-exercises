# Milestone & branch protection starter file (your 02-first-resource config).
# Export your token first:  export TF_VAR_github_token=ghp_...
# Add the milestone, the milestone_number link, and branch protection (see the docs).

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  token = var.github_token
}

variable "github_token" {
  type      = string
  sensitive = true
}

resource "github_repository" "workshop_app" {
  name        = "beamops-workshop-app"
  description = "Built during BEAMOps Terraform 101"
  visibility  = "private"
  has_issues  = true
}

locals {
  workshop_issues = {
    "pin-providers" = "Pin provider versions with a lock file"
    "remote-state"  = "Move Terraform state to a remote backend"
    "sops-secrets"  = "Encrypt secrets with SOPS and age"
  }
}

resource "github_issue" "workshop_issues" {
  for_each   = local.workshop_issues
  repository = github_repository.workshop_app.name
  title      = each.value
  # TODO: link each issue to the milestone with milestone_number
}

# TODO: add a github_repository_milestone (owner, repository, title)
# TODO: add github_branch_protection on "main" with a required_pull_request_reviews block
