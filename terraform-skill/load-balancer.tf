resource "aws_lb" "app-lb" {
  name               = "Application-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.dmz_subnet.*.id
  tags = {
    Name = "Application-LoadBalancer"
  }
}

resource "aws_alb_target_group" "target-group" {
  name        = "TargetGroup"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.prodvpc.id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    matcher             = 200
    path                = "/"
    timeout             = 14
    interval            = 15
  }
}

resource "aws_alb_target_group_attachment" "register-targets" {
  count            = 2
  target_group_arn = aws_alb_target_group.target-group.arn
  target_id        = aws_instance.server.*.id[count.index]
  port             = 80
}

resource "aws_alb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.target-group.arn
  }
}

resource "aws_security_group" "lb_sg" {
  name   = "lb_sg"
  vpc_id = aws_vpc.prodvpc.id

  # Terraform currently provides both a standalone Security Group Rule resource
  #(a single ingress or egress rule), and a Security Group resource with ingress and egress rules defined in-line.
  # At this time you cannot use a Security Group with in-line rules in conjunction with any Security Group Rule resources.
  # Doing so will cause a conflict of rule settings and will overwrite rules.
  # Uncomment the below ingress and egress block if you want the application to be accessed by LB as well as Public IP.
  # Comment the below ingress and egress block if you want the application to be accessed only by LB not directly by Public IP
  # and create the aws_security_group_rule resource for ingress and egress rules

  /* ingress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Traffic going only public subnet"
    from_port   = "0"
    to_port     = "65535"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }*/

  tags = {
    Name = "LB-Sg"
  }
}

resource "aws_security_group_rule" "internal-rule" {
  type              = "ingress"
  from_port         = "0"
  to_port           = "65535"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "pub-rule" {
  type                     = "egress"
  from_port                = "80"
  to_port                  = "80"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.lb_sg.id
  source_security_group_id = aws_security_group.prodsg.id
}
