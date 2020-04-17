

resource aws_vpc "lavpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "la-vpc"
  }
}

resource "aws_internet_gateway" "laigw" {
  vpc_id = aws_vpc.lavpc.id

  tags = {
    Name = "la-igw"
  }
}

resource "aws_default_route_table" "privatert" {
  default_route_table_id = aws_vpc.lavpc.default_route_table_id
  tags = {
    Name = "default-rt"
  }
}

resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.lavpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.laigw.id
  }
  tags = {
    Name = "public rt"
  }
}
