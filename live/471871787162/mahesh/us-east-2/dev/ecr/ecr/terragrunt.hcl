locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  customer_vars    = read_terragrunt_config(find_in_parent_folders("customer.hcl"))

  customer_name    = local.customer_vars.locals.customer_name
  environment_name = local.environment_vars.locals.environment
}

terraform {
  source = "git@github.com:maheshglm/aws-infra.git//modules/ecr/v0.33.0?ref=feature/build-ecr-eks-modules"
}

include {
  path = find_in_parent_folders()
}

dependency "unique_id" {
  config_path = "../../unique_id"
}

dependency "readonly_user" {
  config_path = "../iam/ro_user"
}

dependency "readwrite_user" {
  config_path = "../iam/rw_user"
}

inputs = {
  #to avoid creating resources (repositories, policies) through IAC, make enabled as false
  enabled                    = true
  scan_images_on_push        = true
  image_names                = [
    "test_repo"
  ]

  image_tag_mutability       = "MUTABLE"
  principals_full_access     = [dependency.readwrite_user.outputs.iam_user_arn]
  principals_readonly_access = [dependency.readonly_user.outputs.iam_user_arn]

  # tags for repo
  customer    = local.customer_name
  environment = local.environment_name
}

