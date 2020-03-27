variable "aws_region" {}
variable "aws_profile" {}
variable "vpc_cidr" {}
variable "public_subnet" {
  type = list
}
variable "private_subnet" {
  type = list
}
variable "rds_subnet" {
  type = list
}

variable "localip" {}
variable "bucket-name" {}
variable "db_instance_name" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {}
variable "instance_type" {}
variable "key_name" {}
variable "public_key" {}
variable "elb_timeout" {}
variable "elb_interval" {}
variable "elb_healthy_threshold" {}
variable "elb_unhealthy_threshold" {}
