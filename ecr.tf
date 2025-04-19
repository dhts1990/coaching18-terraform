resource "aws_ecr_repository" "s3_ecr" {
  name         = "${local.usage_name}-s3-ecr"
  force_delete = true
}

resource "aws_ecr_repository" "sqs_ecr" {
  name         = "${local.usage_name}-sqs-ecr"
  force_delete = true
}

