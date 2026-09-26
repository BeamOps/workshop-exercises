# Create the repository

**Goal:** add a real GitHub repository to your project. Token hardcoded for now; Act 2 switches
to variables.

Keep working in the same **`terraform-101/github-project/main.tf`**, on top of what you did in
the last exercise.

## What you'll do

1. Add a token to the `provider "github"` block (hardcoded, for now, never commit a real one).
2. Add a `github_repository` resource for your app and set the visbility to private and add the `has_issues = true` attribute.
3. `terraform plan` to read the diff, then `terraform apply`: the repository appears on GitHub.
   (Your provider is already initialised from the last exercise.)

## Check your work

```
./validate
```

## Debrief

- What did `plan` show before you applied?
- Where does Terraform record that the repo now exists?
- Why is hardcoding a token a bad habit? (Act 2 fixes it.)
