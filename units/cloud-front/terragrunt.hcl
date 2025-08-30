include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git@github.com:iisyos/terraform-structure-example.git//modules/cloud-front"
}

dependency "s3" {
  config_path = values.s3_path
}

inputs = {
  s3_bucket_id = dependency.s3.outputs.s3_bucket_id
  environment  = values.environment
}
