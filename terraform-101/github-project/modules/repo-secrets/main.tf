terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.2"
    }
  }
}

# One GitHub Actions secret per entry in var.secrets. The same for_each you met
# in Act 2, now inside a reusable module: point it at any repo, hand it a map.
#
# for_each can't take a sensitive value as its key, and the map is sensitive
# because its values are. The secret *names* aren't sensitive, though, so we
# iterate those with nonsensitive() and look each value up (the value stays
# sensitive, and the provider marks plaintext_value sensitive too).
resource "github_actions_secret" "this" {
  for_each        = nonsensitive(toset(keys(var.secrets)))
  repository      = var.repository
  secret_name     = each.key
  plaintext_value = var.secrets[each.key]
}
