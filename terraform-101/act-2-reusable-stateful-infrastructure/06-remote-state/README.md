# Move your state to S3

**Goal:** take your state off your laptop and into the shared S3 bucket we've set up for your
group, with locking.

Same project, **`terraform-101/github-project/main.tf`**, on top of module 05's import work.

## What you'll do

1. We've provisioned an S3 bucket per group and handed you AWS credentials. Export them:
   ```
   export AWS_ACCESS_KEY_ID=...
   export AWS_SECRET_ACCESS_KEY=...
   ```
2. Add a `backend "s3"` block inside your `terraform { }` block: the `bucket` we gave you, a
   `key` **unique to you** (use your name, e.g. `pep/terraform.tfstate`), the `region`, and
   `use_lockfile = true`. This is the S3 backend, not the AWS provider, you're only storing
   state, so there's no `provider "aws"`.
3. `terraform init`: Terraform detects the new backend and offers to migrate your local state.
   Say **yes**.
4. `terraform plan`: no changes, same config, new home. Your `terraform.tfstate` now lives in S3.
5. Look in the bucket, you'll see your state file under your key.

## Check your work

```
./validate
```

The check confirms your project declares an S3 backend with a unique key and locking, and that
the config is valid. The real proof is your state file appearing in the bucket after `init`.

## Debrief

- Why must the `key` be unique per person on a shared bucket?
- How does remote state let a CI pipeline run `terraform plan` on a pull request and `apply` on
  merge?
