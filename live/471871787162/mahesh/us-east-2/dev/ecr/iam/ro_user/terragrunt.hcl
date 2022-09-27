locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  customer_vars    = read_terragrunt_config(find_in_parent_folders("customer.hcl"))

  customer_name    = local.customer_vars.locals.customer_name
  environment_name = local.environment_vars.locals.environment
  name             = format("%s-%s", local.customer_name, local.environment_name)
}

terraform {
  source = "git@github.com:maheshglm/aws-infra.git//modules/iam_user/v5.4.0?ref=feature/build-ecr-eks-modules"
}

include {
  path = find_in_parent_folders()
}

dependency "unique_id" {
  config_path = "../../../unique_id"
}

inputs = {
  customer_name  = local.customer_name
  environment    = local.environment_name
  unique_id      = dependency.unique_id.outputs.id
  iam_user_name  = format("%s-ecr-readonly-user", local.name)
  iam_policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
