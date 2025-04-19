module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 5.9.0"

  cluster_name = "${local.usage_name}-cluster-name"

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = { weight = 100 }
    }
  }

  services = {
    s3-service = {
      task_definition = {
        container_definitions = jsonencode([
          {
            name      = "s3-app"
            image     = aws_ecr_repository.s3_ecr.repository_url
            essential = true
            portMappings = [
              {
                containerPort = 5051
                hostPort      = 5051
              }
            ]
            environment = [
              {
                name  = "AWS_REGION"
                value = var.aws_region
              },
              {
                name  = "BUCKET_NAME"
                value = aws_s3_bucket.app_bucket.bucket
              }
            ]
          }
        ])
      }
      network_configuration = {
        subnets          = module.vpc.public_subnets
        security_groups  = [module.s3_service_sg.security_group_id]
      }
    }

    sqs-service = {
      task_definition = {
        container_definitions = jsonencode([
          {
            name      = "sqs-app"
            image     = aws_ecr_repository.sqs_ecr.repository_url
            essential = true
            portMappings = [
              {
                containerPort = 5052
                hostPort      = 5052
              }
            ]
            environment = [
              {
                name  = "AWS_REGION"
                value = var.aws_region
              },
              {
                name  = "QUEUE_URL"
                value = aws_sqs_queue.app_queue.id
              }
            ]
          }
        ])
      }
      network_configuration = {
        subnets          = module.vpc.public_subnets
        security_groups  = [module.s3_service_sg.security_group_id]
      }
    }
  }
}