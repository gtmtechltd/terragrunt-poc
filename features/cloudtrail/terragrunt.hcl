include "root" {
  path   = find_in_parent_folders("terragrunt.root.hcl")
  expose = true
}

include "accounts" {
  path   = find_in_parent_folders("accounts.hcl")
  expose = true
}

inputs = {
  config = {
    global_tags = jsonencode({
      Owner = "Devops"
    })
  }
}

terraform {
  source = "git::git@github.com:gtmtechltd/terragrunt-poc-modules.git//base?ref=v1.0.0"
}
