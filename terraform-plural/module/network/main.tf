data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "vpc-plural"
  cidr = var.cidr_block

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnet
  public_subnets  = var.public_subnet
  enable_nat_gateway = true

  tags = {
    Name = "module-vpc"
  }
}
