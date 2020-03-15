resource "aws_route_table" "dmzroutetable" {
  vpc_id = aws_vpc.prodvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prodgw.id
  }
  tags = {
    Name = "DMZRouteTable"
  }
}

resource "aws_route_table" "publicroutetable" {
  vpc_id = aws_vpc.prodvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prodgw.id
  }
  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table" "privateroutetable" {
  count = 2
  vpc_id = aws_vpc.prodvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.*.id[count.index]
  }
  tags = {
    Name = "PrivateRouteTable_${count.index + 1}"
  }
}


resource "aws_route_table_association" "dmz_assoc" {
  count = length(aws_subnet.dmz_subnet)
  subnet_id = aws_subnet.dmz_subnet.*.id[count.index]
  route_table_id = aws_route_table.dmzroutetable.id
}

resource "aws_route_table_association" "pub_assoc" {
  count = length(aws_subnet.public_subnet)
  subnet_id = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.publicroutetable.id
}

resource "aws_route_table_association" "priv_assoc" {
  count = length(aws_subnet.private_subnet)
  subnet_id = aws_subnet.private_subnet.*.id[count.index]
  route_table_id = aws_route_table.privateroutetable.*.id[count.index]
}
