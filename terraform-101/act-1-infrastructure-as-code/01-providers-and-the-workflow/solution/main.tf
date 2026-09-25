terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      # Started at "3.6.0" (exact), then loosened to allow newer 3.x releases.
      version = "~> 3.6"
    }
  }
}

# random_pet needs no provider credentials, so `apply` works with no cloud account.
resource "random_pet" "name" {
  length = 2
}

output "pet" {
  value = random_pet.name.id
}
