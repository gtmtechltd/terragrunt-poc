locals {
  org = read_terragrunt_config(find_in_parent_folders("org.hcl"))
}

inputs = {
  config = {
    org = local.org.locals.org
  }
}

generate "injector-variables" {
  path      = "terragrunt-variables.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file("${find_in_parent_folders("variables.tf")}")
}
