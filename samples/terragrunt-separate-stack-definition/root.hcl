generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "ap-northeast-1"
}
EOF
}

# Configure remote state
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-state-example-${get_env("TG_BUCKET_SUFFIX", "")}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region = "ap-northeast-1"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
