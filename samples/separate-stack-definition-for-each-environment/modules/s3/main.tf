resource "aws_s3_bucket" "this" {}

resource "aws_s3_object" "this" {
  bucket       = aws_s3_bucket.this.id
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
