locals {
    environment = values.environment
}

unit "cloud-front" {
  source = "git@github.com:iisyos/terraform-structure-example.git//units/cloud-front"
  path = "cloud-front"

  values = {
    s3_path     = "../s3"
    environment = local.environment
  }
}

unit "s3" {
  source = "git@github.com:iisyos/terraform-structure-example.git//units/s3"
  path = "s3"
}
