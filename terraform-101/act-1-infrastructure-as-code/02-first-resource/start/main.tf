# First resource: the GitHub provider (starter file).
#
# Export your token first:  export TF_VAR_github_token=ghp_...
#
# Follow the README:
#   1. required_providers: integrations/github ~> 6.0
#   2. provider "github" { token = var.github_token }, and variable "github_token"
#   3. a github_repository resource
#   4. issues with for_each over a locals map
#   5. fmt / validate / plan   (stop at plan)

terraform {
  required_providers {
    # TODO: github = { source = "integrations/github", version = "~> 6.0" }
  }
}

# TODO: provider "github" { token = var.github_token }
# TODO: variable "github_token" { type = string, sensitive = true }
# TODO: resource "github_repository" "workshop_app" { ... }
# TODO: locals { workshop_issues = { ... } }
# TODO: resource "github_issue" "workshop_issues" { for_each = local.workshop_issues ... }
