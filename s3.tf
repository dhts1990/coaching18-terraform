resource "aws_s3_bucket" "app_bucket" {
  bucket = "${local.usage_name}-s3-bucket"
}

