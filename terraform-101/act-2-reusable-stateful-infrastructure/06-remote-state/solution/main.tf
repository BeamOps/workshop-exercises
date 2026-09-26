terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.2"
    }
  }

  # The S3 backend, not the AWS provider: you're only storing state in S3.
  # Credentials come from AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY.
  backend "s3" {
    bucket       = "beamops-workshop-state"
    key          = "your-name/terraform.tfstate" # unique per person
    region       = "eu-west-2"
    use_lockfile = true
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

resource "github_issue_label" "workshop" {
  repository = github_repository.workshop_app.name
  name       = "workshop"
  color      = "5319e7"
}

output "repo_url" {
  value = github_repository.workshop_app.html_url
}
