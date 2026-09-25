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

resource "github_repository_milestone" "roadmap" {
  owner      = split("/", github_repository.workshop_app.full_name)[0]
  repository = github_repository.workshop_app.name
  title      = "Workshop roadmap"
}

locals {
  workshop_issues = {
    "pin-providers" = "Pin provider versions with a lock file"
    "remote-state"  = "Move Terraform state to a remote backend"
    "sops-secrets"  = "Encrypt secrets with SOPS and age"
  }
}

resource "github_issue" "workshop_issues" {
  for_each         = local.workshop_issues
  repository       = github_repository.workshop_app.name
  title            = each.value
  milestone_number = github_repository_milestone.roadmap.number
}

resource "github_branch_protection" "main" {
  repository_id = github_repository.workshop_app.node_id
  pattern       = "main"

  required_pull_request_reviews {
    required_approving_review_count = 1
  }
}
