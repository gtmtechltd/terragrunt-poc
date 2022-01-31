# simple-iam-role

This feature demonstrates writing a simple IAM role in all accounts specified in the `org.hcl` file.

According to `config.hcl`:

* Terraform will assume the `my-security-admin-role` in all accounts mentioned in `org.hcl`
* For each one it will call the module `git::git@github.com:gtmtechltd/terragrunt-poc-modules//features/simple-iam-role` passing through the provider in question
* This module will place the IAM role in the account

It will do this across all accounts as part of one "feature", and using one "statefile" for the feature
