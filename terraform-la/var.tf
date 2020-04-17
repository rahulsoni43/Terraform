variable aws_region {}
variable project_name {}
variable cidr_block {}
variable public_cidrs {
  type = list
}
variable myip {}

variable key_name {}

variable public_key_path {}

variable "instance_count" {
  default = 1
}
variable "instance_type" {}
