# outputs.tf

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.cluster_id
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.app_bucket.bucket
}

output "sqs_queue_url" {
  description = "URL of the SQS queue"
  value       = aws_sqs_queue.app_queue.id
}

output "s3_ecr_url" {
  description = "URL of the S3 ECR repository"
  value       = aws_ecr_repository.s3_ecr.repository_url
}

output "sqs_ecr_url" {
  description = "URL of the SQS ECR repository"
  value       = aws_ecr_repository.sqs_ecr.repository_url
}