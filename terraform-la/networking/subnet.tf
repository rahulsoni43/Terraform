data "aws_availability_zones" "available" {}

resource "aws_subnet" "public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.lavpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

resource "aws_route_table_association" "route_assc" {
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  count          = length(aws_subnet.public_subnet)
  route_table_id = aws_route_table.publicrt.id
}

resource "aws_security_group" "lasg" {
  name   = "public_sg"
  vpc_id = aws_vpc.lavpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.myip}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.myip}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
