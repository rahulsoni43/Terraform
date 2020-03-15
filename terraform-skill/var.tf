variable aws_region {
  default = "ap-south-1"
}

variable vpc_cidr {
  default = "192.168.0.0/19"
}

variable public_cidrs {
  default = ["192.168.4.0/23","192.168.6.0/23"]
}

variable dmz_cidrs {
  default = ["192.168.0.0/23","192.168.2.0/23"]
}

variable private_cidrs {
  default = ["192.168.8.0/23","192.168.10.0/23"]
}
