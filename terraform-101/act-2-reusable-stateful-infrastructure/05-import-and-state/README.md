# Import a resource and read your state

**Goal:** feel the ClickOps problem, then fix it. Create a label by hand on GitHub, bring it
under Terraform with an import block, then inspect your state with the state commands and the
console.

Same project, **`terraform-101/github-project/main.tf`**, on top of everything from module 04.

## What you'll do

1. Reapply your configuration to create your repository and milestone again if you deleted it at the end of the last section.
2. **ClickOps a label.** On GitHub, create a new label. To do this go to one of your milestones, try to assign a label and in the process create a new one. Name
   it `workshop`, pick any colour. Terraform knows nothing about it.
3. **Import it into your configuration using an import block.** Remember to add the appropriate GitHub issue resource for that label in your configuration. The import ID for a label is `repository:name`, e.g.
   `beamops-workshop-app:workshop` (see the
   [provider docs](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_label)).
4. `terraform plan` to preview the import, and once you are happy that the resource will not be updated during the import, run `terraform apply`. Delete the `import` block
   once it succeeds, it's a one-time migration.
5. **Read your state.** Run `terraform state list`, then `terraform state show` using your github label resource address. Open `terraform console` and read an attribute of your label resource such as its colour. See if you can use a Terraform function to capitalise the colour value.

## Check your work

```
./validate
```

The check confirms your project declares the label, references the repo, and is valid. The real
proof is `state show` finding the label you clicked, now under Terraform's management.

## Debrief

- Before importing, what would `terraform plan` want to do with a label Terraform can't see?
- Why is an import block better than clicking, or than the older `terraform import` CLI command?
