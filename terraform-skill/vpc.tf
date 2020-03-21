data "aws_availability_zones" "available" {}

resource "aws_vpc" "prodvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "ProdVPC"
  }
}

resource "aws_internet_gateway" "prodgw" {
  vpc_id = aws_vpc.prodvpc.id

  tags = {
    Name = "ProdIGW"
  }
}

resource "aws_nat_gateway" "ngw" {
  count         = 2
  allocation_id = aws_eip.nat.*.id[count.index]
  subnet_id     = aws_subnet.public_subnet.*.id[count.index]

  tags = {
    Name = "Ngw_${count.index + 1}"
  }
}

resource "aws_eip" "nat" {
  count = 2
}

resource "aws_security_group" "prodsg" {
  name   = "prodsg"
  vpc_id = aws_vpc.prodvpc.id

  # Terraform currently provides both a standalone Security Group Rule resource
  #(a single ingress or egress rule), and a Security Group resource with ingress and egress rules defined in-line.
  # At this time you cannot use a Security Group with in-line rules in conjunction with any Security Group Rule resources.
  # Doing so will cause a conflict of rule settings and will overwrite rules.

  /*  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow only from External LB"
    from_port   = "0"
    to_port     = "65535"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}*/

  tags = {
    Name = "ProdSg"
  }
}

resource "aws_security_group_rule" "lb-rule" {
  type                     = "ingress"
  from_port                = "80"
  to_port                  = "80"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.prodsg.id
  source_security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "egress-rule" {
  type              = "egress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  security_group_id = aws_security_group.prodsg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
