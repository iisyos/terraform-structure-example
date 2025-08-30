stack "staging" {
  source = "../../../../stacks/cloud-front-s3-service"

  path = "staging"

  values = {
    environment = "staging"
  }
}
