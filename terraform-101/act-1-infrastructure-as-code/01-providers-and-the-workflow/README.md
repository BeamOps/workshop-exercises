# Providers and the workflow

**Goal:** get fluent with the Terraform toolchain and the provider registry, without
touching a cloud account. You'll declare two providers, run the core commands, and
explore HCL in the console. **No credentials needed.**

> _Draft scaffold — the full step-by-step lands in the next iteration._

## What you'll do

1. Open `start/main.tf`. It's deliberately messy and declares no providers yet.
2. On the [Terraform Registry](https://registry.terraform.io), find two providers:
   one **SaaS** (e.g. GitHub, `integrations/github`) and one **cloud** (e.g. AWS,
   `hashicorp/aws`). Copy their entries into a `required_providers` block.
3. `terraform init` — download both providers, then look at `.terraform.lock.hcl`.
4. `terraform init -upgrade` — watch the lock file update.
5. `terraform fmt` — it fixes the messy formatting.
6. `terraform validate` — confirm the config is valid.
7. Add a `terraform_data` resource (built into Terraform, no provider, no
   credentials), then `terraform plan` — you'll see a real `+ create` with no cloud
   account.
8. `terraform console` — HCL is a language. Try:
   ```
   > max(5, 12, 9)
   > join("-", ["a", "b", "c"])
   > upper("hcl")
   ```

Nothing here creates real infrastructure. The next exercise does.

## Check your work

```
./validate
```

## Debrief

- What did `terraform init` download, and what did the lock file record?
- What's the difference between `validate` and `plan`?
- When would you reach for `terraform console`?
