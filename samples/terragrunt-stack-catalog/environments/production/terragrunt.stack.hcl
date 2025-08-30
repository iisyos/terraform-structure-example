stack "production" {
  source = "../../../../stacks/cloud-front-s3-service"

  path = "production"

  values = {
    environment = "production"
  }
}
