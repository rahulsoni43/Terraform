resource "aws_security_group" "devsg" {
  name   = "devsg"
  vpc_id = aws_vpc.publicvpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "DevSG"
  }
}

resource "aws_security_group" "publicsg" {
  name   = "publicsg"
  vpc_id = aws_vpc.publicvpc.id

  #SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PublicSG"
  }
}

resource "aws_security_group" "privatesg" {
  name   = "privatesg"
  vpc_id = aws_vpc.publicvpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.1.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PrivateSG"
  }
}

resource "aws_security_group" "rdsg" {
  name   = "rdsg"
  vpc_id = aws_vpc.publicvpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.devsg.id, aws_security_group.privatesg.id, aws_security_group.publicsg.id]
  }

  tags = {
    Name = "RDS-SG"
  }

}
