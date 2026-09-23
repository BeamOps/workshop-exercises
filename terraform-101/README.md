# Terraform 101 exercises

_Coming soon._

Placeholder for the Terraform 101 hands-on exercises, structured the same way as
[`docker-101/`](../docker-101/): one directory per exercise with `start/`,
`solution/`, and a `./validate` self-check, grouped by the workshop's acts:

1. **Infrastructure as code** — why IaC, fundamentals, first GitHub provider resource
2. **Reusable, stateful infrastructure** — variables/locals/for_each, remote state
3. **Secrets and automated delivery** — SOPS-encrypted secrets, OIDC continuous deployment

Validators here will likely shell out to `terraform`/`tofu` and check plan/apply
output, so the requirements differ from Docker 101 (see the workshop notes).
