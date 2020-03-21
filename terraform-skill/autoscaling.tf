data "template_file" "user_data" {
  template = file("${path.module}/auto.tpl")
  vars = {
    az = aws_alb_target_group.target-group.name
  }
}

resource "aws_launch_configuration" "launch-conf" {
  image_id        = data.aws_ami.server_ami.id
  instance_type   = var.instance_type
  user_data       = data.template_file.user_data.rendered
  security_groups = [aws_security_group.prodsg.id]
  key_name        = aws_key_pair.auth.id
}

resource "aws_autoscaling_group" "autoscale" {
  launch_configuration      = aws_launch_configuration.launch-conf.id
  max_size                  = 4
  min_size                  = 2
  vpc_zone_identifier       = aws_subnet.public_subnet.*.id
  health_check_grace_period = 300
  health_check_type         = "ELB"
  termination_policies      = ["OldestInstance"]
  target_group_arns         = [aws_alb_target_group.target-group.arn]

  tag {
    key                 = "Name"
    value               = "AutoScaling"
    propagate_at_launch = "true"
  }
}

resource "aws_autoscaling_policy" "up-policy" {
  name                   = "up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.autoscale.name
}

resource "aws_autoscaling_notification" "up_notifications" {
  group_names = [
    aws_autoscaling_group.autoscale.name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
    "autoscaling:TEST_NOTIFICATION"
  ]

  topic_arn = aws_sns_topic.scaleup_alarm.arn
}

resource "aws_autoscaling_policy" "down-policy" {
  name = "down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.autoscale.name
}

resource "aws_autoscaling_notification" "down_notifications" {
  group_names = [
    aws_autoscaling_group.autoscale.name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
    "autoscaling:TEST_NOTIFICATION"
  ]

  topic_arn = aws_sns_topic.scaledown_alarm.arn
}

resource "aws_cloudwatch_metric_alarm" "HighCPU" {
  alarm_name                = "HighCPU"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "5"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "80"

  dimensions = {
  AutoScalingGroupName = "${aws_autoscaling_group.autoscale.name}"
}

  alarm_description = "This metric monitors ec2 High cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.up-policy.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "LowCPU" {
  alarm_name                = "LowCPU"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "5"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "30"
  alarm_description         = "This metric monitors ec2 Low cpu utilization"

  dimensions = {
  AutoScalingGroupName = "${aws_autoscaling_group.autoscale.name}"
}

  alarm_actions     = ["${aws_autoscaling_policy.down-policy.arn}"]
}
