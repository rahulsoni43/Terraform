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
  count = 2
  allocation_id = aws_eip.nat.*.id[count.index]
  subnet_id     = aws_subnet.public_subnet.*.id[count.index]

  tags = {
    Name = "Ngw_${count.index + 1}"
  }
}

resource "aws_eip" "nat" {
  count = 2
  
}
