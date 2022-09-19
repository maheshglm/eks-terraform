locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  customer_vars    = read_terragrunt_config(find_in_parent_folders("customer.hcl"))
  // project_vars     = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  account_name  = local.account_vars.locals.account_name
  account_id    = local.account_vars.locals.aws_account_id
  customer_name = local.customer_vars.locals.customer_name
  // project_name  = local.project_vars.locals.project_name
  aws_region    = local.region_vars.locals.aws_region
  environment   = local.environment_vars.locals.environment
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  allowed_account_ids = ["${local.account_id}"]
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${get_env("TG_BUCKET_PREFIX", "")}${local.aws_region}-terraform-remote-state-${local.account_name}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}