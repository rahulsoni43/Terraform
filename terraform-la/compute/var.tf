variable aws_region {
  default = "ap-south-1"
}
variable key_name {
  default = "tf-auth"
}
variable "public_key_path" {
  default = "/home/ubuntu/.ssh/id_rsa.pub"
}
variable "subnet_ips" {
  type = list
}
variable "instance_count" {}
variable "instance_type" {}
variable "security_group" {}
variable "subnets" {}
