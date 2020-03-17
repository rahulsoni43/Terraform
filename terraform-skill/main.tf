data "aws_ami" "server_ami" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "appinit" {
  count    = 2
  template = file("${path.module}/userdata.tpl")

  vars = {
     firewall_subnets = element(aws_subnet.dmz_subnet.*.cidr_block, count.index)
   }
}

resource "aws_instance" "server" {
  count                  = var.instance_count
  vpc_security_group_ids = [aws_security_group.prodsg.id]
  ami                    = data.aws_ami.server_ami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.auth.id
  subnet_id              = aws_subnet.public_subnet.*.id[count.index]
  user_data              = data.template_file.appinit.*.rendered[count.index]

  tags = {
    Name = "server_${count.index + 1}"
  }
}

resource "aws_key_pair" "auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_s3_bucket" "bucket" {
  bucket        = var.project_name
  force_destroy = true
  acl           = "private"
  tags = {
    Name = "Prod Bucket"
  }
}
