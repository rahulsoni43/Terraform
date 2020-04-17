provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*18.04-amd64-server-*"]

  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jenkins" {
  instance_type = var.instance_type
  ami = data.aws_ami.ubuntu.id
  key_name = var.keyname
  user_data = data.template_file.jenkins.rendered
  iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name

  tags = {
    Name = "Jenkins"
  }
}

data "template_file" "jenkins" {
  template = file("jenkins-init.sh")
  vars = {
    TERRAFORM_VERSION = var.TERRAFORM_VERSION
  }
}

resource "aws_instance" "app-instance" {
  ami = var.INSTANCE_ID
  count = var.APP_INSTANCE_COUNT
  instance_type = var.instance_type
  key_name = var.keyname

  tags = {
    Name = "Application"
  }
}
