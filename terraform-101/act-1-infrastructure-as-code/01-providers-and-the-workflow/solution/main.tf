terraform {
  required_providers {
    github = {
      source = "integrations/github"
      # Started at "6.2.0" (exact), then loosened to allow newer 6.x releases.
      version = "~> 6.2"
    }
  }
}
