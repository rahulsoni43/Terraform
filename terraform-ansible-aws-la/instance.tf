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


resource "aws_instance" "dev_instance" {
  count                  = 1
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.publicsg.id]
  key_name               = "pkey"
  subnet_id              = aws_subnet.public_subnet.*.id[count.index]
  iam_instance_profile   = aws_iam_instance_profile.s3_access_profile.id
  user_data              = data.template_file.appinit.*.rendered[count.index]
  provisioner "local-exec" {
    command = "echo ${join(", ", aws_instance.dev_instance.*.public_ip)} >> aws_hosts"

  }

  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --private-key=./pkey.pem -i aws_hosts wordpress.yml"
  }

  tags = {
    Name = "wordpress-instance"
  }
}

/*resource "aws_elb" "elb" {
  name               = "terraform-elb"
  subnets = aws_subnet.public_subnet.*.id

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold = var.elb_healthy_threshold
    unhealthy_threshold = var.elb_unhealthy_threshold
    timeout = var.elb_timeout
    interval = var.elb_interval
    target              = "TCP:80"
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "terraform-elb"
  }
}
*/
