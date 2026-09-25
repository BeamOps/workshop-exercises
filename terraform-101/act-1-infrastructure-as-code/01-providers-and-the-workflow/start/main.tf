# Providers, versions, and the lock file — starter file.
#
# Follow the README:
#   1. Add the random provider (hashicorp/random) pinned to exactly 3.6.0.
#   2. init, inspect with `terraform providers`, then init -upgrade (nothing changes).
#   3. Loosen the version to ~> 3.6 and init -upgrade again.
#   4. Add a random_pet resource and an output, then plan, apply, console, and destroy.

terraform {
  required_providers {
    # TODO: add hashicorp/random, version = "3.6.0"
  }
}

# TODO: add a random_pet resource (no credentials needed) and an output for its name.
