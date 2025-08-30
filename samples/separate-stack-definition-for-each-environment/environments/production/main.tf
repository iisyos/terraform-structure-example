provider "aws" {}

terraform {
  backend "s3" {}
}

module "s3" {
  source = "../../modules/s3"
}

module "cloud-front" {
  source = "../../modules/cloud-front"

  s3_bucket_id = module.s3.s3_bucket_id
  environment  = "production"
}

output "domain_name" {
  value = module.cloud-front.cloudfront_domain_name
}
