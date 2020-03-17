resource "aws_lb" "app-lb" {
  name = "Application-LB"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.lb_sg.id]
  subnets = aws_subnet.dmz_subnet.*.id
  tags = {
    Name = "Application-LoadBalancer"
  }
}

resource "aws_alb_target_group" "target-group" {
  name = "TargetGroup"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.prodvpc.id
  target_type = "instance"

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 5
    matcher = 200
    path = "/"
    timeout = 14
    interval = 15
  }
}

resource "aws_alb_target_group_attachment" "register-targets" {
  count = 2
  target_group_arn = aws_alb_target_group.target-group.arn
  target_id = aws_instance.server.*.id[count.index]
  port = 80
}

resource "aws_alb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.app-lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.target-group.arn
  }
}

resource "aws_security_group" "lb_sg" {
  name   = "lb_sg"
  vpc_id = aws_vpc.prodvpc.id

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "LB-Sg"
  }
}
