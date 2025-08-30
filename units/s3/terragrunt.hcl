include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git@github.com:iisyos/terraform-structure-example.git//modules/s3"
}
