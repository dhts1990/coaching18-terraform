#  data "aws_subnets" "default" {
#   filter {
#    name   = "vpc-id"
#     values = [module.vpc.vpc_id]
#   }
# }

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.usage_name}-vpc-tf"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "prod"
    Created_by = "LH"
  }
}

module "s3_service_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.0"

  name        = "${local.usage_name}-s3-ecs-sg"
  description = "Security group for S3 service"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 5051
      to_port     = 5051
      protocol    = "tcp"
      description = "S3 Service Inbound"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_rules = ["all-all"]
}

module "sqs_service_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.0"

  name        = "${local.usage_name}-sqs-ecs-sg"
  description = "Security group for SQS service"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 5052
      to_port     = 5052
      protocol    = "tcp"
      description = "SQS Service Inbound"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_rules = ["all-all"]
}