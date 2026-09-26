terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.2"
    }
  }

  # The S3 backend from Act 2. CI reads this same state to plan and apply.
  # Credentials come from AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY.
  backend "s3" {
    bucket       = "beamops-workshop-state"
    key          = "your-name/terraform.tfstate" # the group driver's key from Act 2
    region       = "eu-west-2"
    use_lockfile = true
  }
}

variable "github_token" {
  type        = string
  description = "GitHub personal access token (repo scope)"
  sensitive   = true
}

variable "aws_access_key_id" {
  type        = string
  description = "Group AWS access key id, mirrored into a repo secret for CI"
  sensitive   = true
}

variable "aws_secret_access_key" {
  type        = string
  description = "Group AWS secret access key, mirrored into a repo secret for CI"
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

resource "github_issue_label" "workshop" {
  repository = github_repository.workshop_app.name
  name       = "workshop"
  color      = "5319e7"
}

# The CD pipeline's credentials, stored as GitHub Actions secrets on the repo,
# as code, via our local repo-secrets module. The runner reads these to reach
# the S3 backend and the GitHub API.
module "cd_secrets" {
  source     = "./modules/repo-secrets"
  repository = github_repository.workshop_app.name
  secrets = {
    AWS_ACCESS_KEY_ID     = var.aws_access_key_id
    AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
    GH_TOKEN              = var.github_token
  }
}

output "repo_url" {
  value = github_repository.workshop_app.html_url
}
