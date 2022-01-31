locals {
  account_groups = {
    all = {
      account_filter_regex = ".*",   # all accounts
      source               = "git::git@github.com:gtmtechltd/terragrunt-poc-modules//features/simple-iam-role?ref=v0.0.2",
      providers            = {
        "security-admin"   = {
          "path"    = "my-security-admin-role",
          "regions" = [ "us-east-1" ]
        }
      },
      variables            = {}
    }
  }
}
