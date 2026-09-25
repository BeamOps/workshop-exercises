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
}
