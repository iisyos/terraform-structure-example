provider "aws" {}

terraform {
  backend "s3" {}
}

module "s3" {
  source = "git@github.com:iisyos/terraform-structure-example.git//modules/s3?ref=v1.1.0"
}

module "cloud-front" {
  source = "git@github.com:iisyos/terraform-structure-example.git//modules/cloud-front?ref=v1.1.0"

  s3_bucket_id = module.s3.s3_bucket_id
  environment  = "production"
}

output "domain_name" {
  value = module.cloud-front.cloudfront_domain_name
}
