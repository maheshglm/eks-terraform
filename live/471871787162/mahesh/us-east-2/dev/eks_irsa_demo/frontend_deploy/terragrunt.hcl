locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  customer_vars    = read_terragrunt_config(find_in_parent_folders("customer.hcl"))

  aws_account_id   = local.account_vars.locals.aws_account_id
  customer_name    = local.customer_vars.locals.customer_name
  aws_region       = local.region_vars.locals.aws_region
  environment_name = local.environment_vars.locals.environment
}

terraform {
  source = ".//src"
}


include {
  path = find_in_parent_folders()
}

dependency "eks" {
  config_path = "../../eks_with_module"
}

dependency "s3_irsa" {
  config_path = "../s3_irsa"
}

inputs = {
  cluster_endpoint = dependency.eks.outputs.cluster_endpoint
  cluster_ca       = dependency.eks.outputs.cluster_certificate_authority_data
  cluster_token    = dependency.eks.outputs.cluster_token
  s3_role_arn      = dependency.s3_irsa.outputs.s3_role_arn
  sa_name          = "s3-irsa-test"
}