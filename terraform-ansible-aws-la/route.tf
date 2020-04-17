resource "aws_vpc" "publicvpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.publicvpc.id

  tags = {
    Name = "MyIGW"
  }

}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.publicvpc.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.public_route.id, aws_route_table.private_route.id]
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.publicvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.publicvpc.id

  tags = {
    Name = "private_route"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private_assoc" {
  count          = 2
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
  route_table_id = aws_route_table.private_route.id
}
