data "aws_s3_bucket" "this" {
  bucket = var.s3_bucket_id
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name              = data.aws_s3_bucket.this.bucket_regional_domain_name
    origin_id                = data.aws_s3_bucket.this.id
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  enabled             = true
  default_root_object = "index.html"
  default_cache_behavior {
    target_origin_id       = data.aws_s3_bucket.this.id
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

resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.environment}-oac"
  description                       = "OAC for ${var.environment}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "PolicyForCloudFrontPrivateContent"
    actions   = ["s3:GetObject"]
    resources = ["${data.aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = data.aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}
