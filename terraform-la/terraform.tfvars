aws_region   = "ap-south-1"
project_name = "la-terraform"
cidr_block   = "10.123.0.0/16"
public_cidrs = [
  "10.123.1.0/24",
  "10.123.2.0/24"
]
myip            = "120.138.124.154/32"
instance_type   = "t2.micro"
instance_count  = 2
key_name        = "tf_auth"
public_key_path = "/home/ubuntu/.ssh/id_rsa.pub"
