provider "aws" {}

terraform {
  backend "s3" {}
}

resource "aws_s3_bucket" "staging" {
  force_destroy = true
}

resource "aws_cloudfront_distribution" "staging" {
  origin {
    domain_name              = aws_s3_bucket.staging.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.staging.id
    origin_access_control_id = aws_cloudfront_origin_access_control.staging.id
  }

  enabled             = true
  default_root_object = "index.html"
  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.staging.id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_origin_access_control" "staging" {
  name                              = "staging-oac"
  description                       = "OAC for staging"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_iam_policy_document" "staging" {
  statement {
    sid       = "PolicyForCloudFrontPrivateContent"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.staging.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.staging.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "staging" {
  bucket = aws_s3_bucket.staging.id
  policy = data.aws_iam_policy_document.production.json
}

resource "aws_s3_object" "staging" {
  bucket       = aws_s3_bucket.staging.id
  key          = "index.html"
  content      = <<EOF
<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Hello</title>
  </head>
  <body>
    Hello World
  </body>
</html>
EOF
  content_type = "text/html; charset=utf-8"
}

output "staging_cloudfront_domain_name" {
  value = aws_cloudfront_distribution.staging.domain_name
}

resource "aws_s3_bucket" "production" {
  force_destroy = true
}

resource "aws_cloudfront_distribution" "production" {
  origin {
    domain_name              = aws_s3_bucket.production.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.production.id
    origin_access_control_id = aws_cloudfront_origin_access_control.production.id
  }

  enabled             = true
  default_root_object = "index.html"
  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.production.id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_origin_access_control" "production" {
  name                              = "production-oac"
  description                       = "OAC for production"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_iam_policy_document" "production" {
  statement {
    sid       = "PolicyForCloudFrontPrivateContent"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.production.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.production.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "production" {
  bucket = aws_s3_bucket.production.id
  policy = data.aws_iam_policy_document.production.json
}

resource "aws_s3_object" "production" {
  bucket       = aws_s3_bucket.production.id
  key          = "index.html"
  content      = <<EOF
<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Hello</title>
  </head>
  <body>
    Hello World
  </body>
</html>
EOF
  content_type = "text/html; charset=utf-8"
}

output "production_cloudfront_domain_name" {
  value = aws_cloudfront_distribution.production.domain_name
}
