module "pki-worker" {
  source = "./pki-worker"
  env = var.env
  prefix = var.prefix
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.prefix}${var.vpc_name}"
  cidr = "10.11.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.11.1.0/24", "10.11.2.0/24", "10.11.3.0/24"]
  public_subnets  = ["10.11.101.0/24", "10.11.102.0/24", "10.11.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = var.env
  }
}