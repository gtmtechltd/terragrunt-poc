locals {
  account_groups = {
    master = {
      account_filter_regex = "master",
      source               = "git::git@github.com:gtmtechltd/terragrunt-poc-modules//features/cloudtrail/master?ref=v0.0.2",
      providers            = {
        "org-viewer"       = {
          "path"    = "my-org-admin-role",
          "regions" = [ "us-east-1" ]
        }
      },
      variables            = {
        "environment" = "\"master\""
      }
    },
    audit-dev = {
      account_filter_regex = "audit-dev",
      source               = "git::git@github.com:gtmtechltd/terragrunt-poc-modules//features/cloudtrail/audit?ref=v0.0.2",
      providers            = {
        "security-admin" = {
          "path"    = "my-security-admin-role",
          "regions" = [ "us-east-1" ]
        }
      },
      variables            = {
        "environment"  = "\"dev\""
        "org_accounts" = "module.master.accounts"
      }
    },
    tenants-dev = {
      account_filter_regex = "tenant-.*-dev",
      source               = "git::git@github.com:gtmtechltd/terragrunt-poc-modules//features/cloudtrail/tenant?ref=v0.0.2",
      providers            = {
        "security-admin" = {
          "path"    = "my-security-admin-role",
          "regions" = [ "us-east-1" ]
        }
      },
      variables            = {
        "environment"            = "\"dev\""
        "cloudtrail_bucket_name" = "module.audit-dev.cloudtrail_bucket_name"
      }
    }
    audit-prod = {
      account_filter_regex = "audit-prod",
      source               = "git::git@github.com:gtmtechltd/terragrunt-poc-modules//features/cloudtrail/audit?ref=v0.0.2",
      providers            = {
        "security-admin" = {
          "path"    = "my-security-admin-role",
          "regions" = [ "us-east-1" ]
        }
      },
      variables            = {
        "environment"  = "\"prod\""
        "org_accounts" = "module.master.accounts"
      }
    },
    tenants-prod = {
      account_filter_regex = "tenant-.*-prod",
      source               = "git::git@github.com:gtmtechltd/terragrunt-poc-modules//features/cloudtrail/tenant?ref=v0.0.2",
      providers            = {
        "security-admin" = {
          "path"    = "my-security-admin-role",
          "regions" = [ "us-east-1" ]
        }
      },
      variables            = {
        "environment"            = "\"prod\""
        "cloudtrail_bucket_name" = "module.audit-prod.cloudtrail_bucket_name"
      }
    }
  }
}
