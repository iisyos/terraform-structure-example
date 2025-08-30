include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "git@github.com:iisyos/terraform-structure-example.git//modules/cloud-front"
}

dependency "s3" {
  config_path = "../s3"
}

inputs = {
  s3_bucket_id = dependency.s3.outputs.s3_bucket_id
  environment  = local.env_vars.locals.env
}
