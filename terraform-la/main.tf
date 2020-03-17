provider "aws" {
  region     = var.aws_region
  secret_key = "eCbX7t30Ll5vvHgVk+GZJSZpVn4SzbgW7SlcUg1K"
  access_key = "AKIAVRPP7FFVQKTTYK5G"
}

terraform {
  backend "s3" {
    bucket = "la-terraform-4387"
    key = "terraform.tfstate"
    region = "ap-south-1"
  }
}

module "storage" {
  source       = "./terraform-la/storage"
  project_name = "${var.project_name}"
}

module "networking" {
  source       = "./terraform-la/networking"
  cidr_block   = var.cidr_block
  public_cidrs = var.public_cidrs
  myip         = var.myip
}

module "compute" {
  source          = "./terraform-la/compute"
  instance_count  = var.instance_count
  key_name        = var.key_name
  public_key_path = var.public_key_path
  instance_type   = var.instance_type
  subnets         = module.networking.public_subnets
  security_group  = module.networking.security_groups
  subnet_ips      = module.networking.subnet_ips
}
