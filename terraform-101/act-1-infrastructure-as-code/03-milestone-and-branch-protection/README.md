# A milestone that depends on the repo

**Goal:** add a milestone that references the repository. The reference is an implicit
dependency, so Terraform creates the repo first. Apply and destroy for real.

Same project, **`terraform-101/github-project/main.tf`**, on top of the repo you just created.

## What you'll do

1. Using the [provider docs](https://registry.terraform.io/providers/integrations/github/latest/docs),
   add a `github_repository_milestone`. Set its `repository` from
   `github_repository.workshop_app.name`, and work out `owner` from the repo's `full_name`
   attribute.
2. `terraform plan`: the milestone comes after the repo, which already exists in your state.
3. `terraform apply`: check the milestone on the repo.
4. `terraform destroy`: tear the whole project down. The milestone goes before the repo,
   dependencies run in reverse.

## Check your work

```
./validate
```

The check confirms your project declares the milestone, references the repo, and is valid. The
real proof is seeing the milestone on GitHub after `apply`.

## Debrief

- How did the reference create the dependency, with no `depends_on`?
- In what order did `destroy` remove the two resources?
