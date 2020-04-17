variable "cidr_block" {}
variable "public_subnet" {}
variable "private_subnet" {}
variable "subnet_count" {
  default = "2"
}

variable "dynamodb_table" {}

variable "aws_networking_bucket" {
  default = "networking-4386"
}

variable "aws_application_bucket" {
  default = "application-4386"
}
