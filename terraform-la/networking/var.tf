variable aws_region {
  default = "ap-south-1"
}
variable "cidr_block" {}
variable "public_cidrs" {
  type = list
}

variable "myip" {}
