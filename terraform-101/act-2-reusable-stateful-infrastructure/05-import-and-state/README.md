# Import a resource and read your state

**Goal:** feel the ClickOps problem, then fix it. Create a label by hand on GitHub, bring it
under Terraform with an import block, then inspect your state with the state commands and the
console.

Same project, **`terraform-101/github-project/main.tf`**, on top of everything from module 04.

## What you'll do

1. **ClickOps a label.** On GitHub, open your repo's Labels page and add a label by hand: name
   it `workshop`, pick any colour. Terraform knows nothing about it.
2. **Adopt it.** Add a `github_issue_label` resource for that label, plus an `import` block that
   points at it. The import ID for a label is `repository:name`, e.g.
   `your-org/beamops-workshop-app:workshop` (see the
   [provider docs](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_label)).
3. `terraform plan` to preview the import, then `terraform apply`. Delete the `import` block
   once it succeeds, it's a one-time migration.
4. **Read your state.** Run `terraform state list`, then `terraform state show
   github_issue_label.workshop`. Open `terraform console` and read an attribute, for example
   `github_issue_label.workshop.color`.

## Check your work

```
./validate
```

The check confirms your project declares the label, references the repo, and is valid. The real
proof is `state show` finding the label you clicked, now under Terraform's management.

## Debrief

- Before importing, what would `terraform plan` want to do with a label Terraform can't see?
- Why is an import block better than clicking, or than the older `terraform import` CLI command?
