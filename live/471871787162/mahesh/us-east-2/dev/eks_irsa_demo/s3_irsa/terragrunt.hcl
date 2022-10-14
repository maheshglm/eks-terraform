locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  customer_vars    = read_terragrunt_config(find_in_parent_folders("customer.hcl"))

  customer_name    = local.customer_vars.locals.customer_name
  environment_name = local.environment_vars.locals.environment
}

terraform {
  source = ".//src"
}

dependency "eks" {
  config_path = "../../eks_with_module"
}

inputs = {
  oidc_provider_issuer_url = dependency.eks.outputs.cluster_oidc_issuer_url
  oidc_provider_arn        = dependency.eks.outputs.oidc_provider_arn
  s3_bucket_arn            = "arn:aws:s3:::mahesh-test-irsa"
  sa_namespace             = "default"
  sa_name                  = "s3-irsa-test"


}