locals {
  orghcl         = read_terragrunt_config("${find_in_parent_folders("org.hcl")}")
  confighcl      = read_terragrunt_config("${get_terragrunt_dir()}/config.hcl")
  org            = local.orghcl.locals.org
  account_groups = local.confighcl.locals.account_groups

  providers = { 
    for account_type, account_spec in local.account_groups:
      account_type => flatten([
        for account_name, account_data in local.org: [
          for roletype, roledata in account_spec["providers"]: [
            for region in roledata["regions"]:
              { "name":       account_name, 
                "account_id": account_data["account_id"],
                "rolepath":   roledata["path"],
                "roletype":   roletype,
                "region":     region
              } if length(regexall( account_spec["account_filter_regex"], account_name )) > 0
          ]
        ]
      ])
  }

  modules = {
    for account_type, account_spec in local.account_groups:
      account_type => flatten([
        for account_name, account_data in local.org:
          { "name":            account_name,
            "source":          account_spec["source"],
            "providers_block": join("\n", flatten([
              "  providers = {",
              [ for roletype, roledata in account_spec["providers"]: [
                for region in roledata["regions"]:
                  format("    aws.%s-%s = aws.%s-%s-%s", roletype, region, account_name, roletype, region)
              ] ],
              "  }"
            ])),
            "variables_block": join("\n", flatten([
              [ for k, v in account_spec["variables"]:
                format("    %s = %s", k, v)
              ]
            ]))
          } if length(regexall( account_spec["account_filter_regex"], account_name )) > 0
      ])
  }

# Using these data lookups, we can populate a list of providers
  provider_template    = file(find_in_parent_folders("providers.tmpl"))
  provider_names       = flatten([ for k, v in local.providers : [ for e in v: e["name"] ] ])        # "for" sorts maps by key
  provider_account_ids = flatten([ for k, v in local.providers : [ for e in v: e["account_id"] ] ])
  provider_roletypes   = flatten([ for k, v in local.providers : [ for e in v: e["roletype"] ] ])
  provider_rolepaths   = flatten([ for k, v in local.providers : [ for e in v: e["rolepath"] ] ])
  provider_regions     = flatten([ for k, v in local.providers : [ for e in v: e["region"] ] ])

# Using these data lookups, we can populate a list of module calls
  module_template     = file(find_in_parent_folders("modules.tmpl"))
  module_names        = flatten([ for k, v in local.modules : [ for e in v: e["name"] ] ])
  module_sources      = flatten([ for k, v in local.modules : [ for e in v: e["source"] ] ])
  module_variables    = flatten([ for k, v in local.modules : [ for e in v: e["variables_block"] ] ])
  module_providers    = flatten([ for k, v in local.modules : [ for e in v: e["providers_block"] ] ])
# module_dependencies = flatten([ for k, v in local.modules : [ for e in v: e["dependencies"] ] ])     # TBD

# Using these arrays, we can populate a list of provider and module blocks
  provider_blocks = formatlist( local.provider_template, local.provider_names, local.provider_roletypes, local.provider_regions, local.provider_regions, local.provider_account_ids, local.provider_rolepaths, local.provider_names, local.provider_roletypes, local.provider_regions )
  module_blocks   = formatlist( local.module_template, local.module_names, local.module_providers, local.module_names, local.module_variables, local.module_sources )

# With these blocks we can write out the tf files
  generated_providers = join("\n", local.provider_blocks)
  generated_modules   = join("\n", local.module_blocks)
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = local.generated_providers
}

generate "modules" {
  path      = "modules.tf"
  if_exists = "overwrite_terragrunt"
  contents  = local.generated_modules
}
