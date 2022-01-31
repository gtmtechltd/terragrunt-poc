# cloudtrail

This feature demonstrates a complicated setup of a cloudtrail feature on the estate.

Such a feature would need to add buckets to the audit accounts, and set up cloudtrails
in the resident accounts which point to the buckets set up in the audit accounts.

According to `config.hcl`:

* Terraform will assume:
  * The `my-org-admin-role` role in the master account to lookup Account IDs
  * The `my-security-admin-role` role in the audit accounts to create buckets and bucket policies
  * The `my-security-admin-role` role in the tenant accounts to create cloudtrails pointing to the respective buckets
* For each account, it will call a different submodule of `git::git@github.com:gtmtechltd/terragrunt-poc-modules//features/cloudtrail` passing through the relevant provider(s) specified
  * In the master account, it will call the `features/cloudtrail/master` module
  * In the audit accounts, it will call the `features/cloudtrail/audit` module
  * In the tenant accounts, it will call the `features/cloudtrail/tenant` module
* These modules set up cross-account cloudtrails as part of one "feature" and one corresponding "statefile"
