terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# No provider blocks and no credentials: we never create a github/aws resource
# here. terraform_data is built into Terraform, so `plan` shows a create with no
# cloud account.
resource "terraform_data" "hello" {
  input = "terraform 101"
}
