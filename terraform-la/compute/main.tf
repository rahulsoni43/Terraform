data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "tf_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)

}

data "template_file" "user-init" {
  count    = 2
  template = file("${path.module}/userdata.tpl")

  vars = {
    firewall_subnets = element(var.subnet_ips, count.index)
  }
}

resource "aws_instance" "server" {
  count                  = 2
  instance_type          = var.instance_type
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.tf_auth.id
  vpc_security_group_ids = [var.security_group]
  subnet_id              = element(var.subnets, count.index)
  user_data              = data.template_file.user-init.*.rendered[count.index]

  tags = {
    Name = "server_${count.index + 1}"
  }
}
