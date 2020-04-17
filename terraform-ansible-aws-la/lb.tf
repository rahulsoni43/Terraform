resource "aws_lb" "wp_lb" {
  name               = "wp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.publicsg.id]
  subnets            = aws_subnet.public_subnet.*.id

  tags = {
    Name = "Wp-LoadBalancer"
  }
}

resource "aws_lb_target_group" "tg-lb" {
  name     = "lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.publicvpc.id

  health_check {
    healthy_threshold   = var.elb_healthy_threshold
    unhealthy_threshold = var.elb_unhealthy_threshold
    timeout             = var.elb_timeout
    interval            = var.elb_interval
    matcher             = 200
  }
}

resource "aws_lb_target_group_attachment" "targetgroupatt" {
  count = 1
  target_group_arn = aws_lb_target_group.tg-lb.arn
  target_id        = aws_instance.dev_instance.*.id[count.index]
  port             = 80
}


resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.wp_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-lb.arn
  }
}
