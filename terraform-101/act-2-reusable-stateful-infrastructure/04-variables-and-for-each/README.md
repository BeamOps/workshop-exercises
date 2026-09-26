# Variables, for_each, and issues

**Goal:** make the project reusable. Move the hardcoded token into a variable, then create a
handful of issues from a single resource with `for_each`. Apply and destroy for real.

Same project, **`terraform-101/github-project/main.tf`**, on top of the repo and milestone you
already have.

## What you'll do

1. Reapply your configuration to create your repository and milestone again if you deleted it at the end of the last section.
2. **Move the token into a variable.** Add a `variable "github_token"` (`type = string`,
   `sensitive = true`, a description), point the provider at `var.github_token`, and delete the
   hardcoded value. Supply it from the environment:
   ```
   export TF_VAR_github_token=ghp_...
   ```
   `terraform plan` should show **no changes**: you've only moved where the value comes from,
   and now `main.tf` is safe to commit.
3. **Add your issues.** Add a `locals` block with an `issues` map (title => body), then create
   them all with a single `github_issue` resource using `for_each`. Set `repository` from
   `github_repository.workshop_app.name`, `title = each.key`, and `body = each.value`.
4. **Add an output** for the repo URL (go to the docs and find the appropriate repository resource attribute to use).
5. `terraform apply`: check the issues on the repo, then `terraform output repo_url`.
6. `terraform destroy`, then apply again. That create, destroy, improve, repeat loop is how you
   know the config is reusable and idempotent.

## Check your work

```
./validate
```

The check confirms the token is a sensitive variable (not hardcoded), your issues use
`for_each`, you declared an output, and the project is valid. The real proof is seeing the
issues on GitHub after `apply`.

## Debrief

- Why is `main.tf` safe to commit now, when it wasn't before?
- You used a map with `for_each`. What would break if you used `count` over a list and removed
  the first item?
