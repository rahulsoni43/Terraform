/*data "aws_ami" "golden_ami" {
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

resource "aws_iam_service_linked_role" "scaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "A service linked role for autoscaling"
  custom_suffix    = "something"

  # Sometimes good sleep is required to have some IAM resources created before they can be used
  provisioner "local-exec" {
    #command = "echo ${join(", ", aws_autoscaling_group.asg.*.private_ip)} > aws_hosts"
     command = "echo ${(aws_autoscaling_group.asg.*.private_ip)} >> aws_hosts"
  }

  provisioner "local-exec" {
    command = "sleep 180; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --private-key=./pkey.pem -i aws_hosts wordpress.yml"
  }

}*/

data "template_file" "appinit" {
  template = file("${path.module}/userdata.tpl")
}

resource "aws_autoscaling_group" "asg" {
  name                      = "autoscaling"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.launch.id
  vpc_zone_identifier       = aws_subnet.private_subnet.*.id
  target_group_arns         = [aws_lb_target_group.tg-lb.arn]
#  service_linked_role_arn   = aws_iam_service_linked_role.scaling.arn

  tag {
    key                 = "Name"
    value               = "ASG"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_launch_configuration" "launch" {
  name_prefix          = "wp_lc-"
  image_id             = data.aws_ami.ubuntu.id
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.privatesg.id]
  iam_instance_profile = aws_iam_instance_profile.s3_access_profile.id
  user_data       =      data.template_file.appinit.rendered
  key_name             = "pkey"

  lifecycle {
    create_before_destroy = true
  }
}
