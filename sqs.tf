resource "aws_sqs_queue" "app_queue" {
  name = "${local.usage_name}-sqs-queue"
}

