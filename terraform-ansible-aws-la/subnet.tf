resource "aws_subnet" "public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.publicvpc.id
  cidr_block              = var.public_subnet[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_Subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = 2
  vpc_id            = aws_vpc.publicvpc.id
  cidr_block        = var.private_subnet[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Private_Subnet_${count.index + 1}"
  }
}

/*resource "aws_subnet" "rds_subnet" {
  count             = 3
  vpc_id            = aws_vpc.publicvpc.id
  cidr_block        = var.rds_subnet[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Rds_Subnet_${count.index + 1}"
  }
}

resource "aws_db_subnet_group" "rds_sub_group" {
  name       = "rds_subnet_group"
  subnet_ids = aws_subnet.rds_subnet.*.id

  tags = {
    Name = "DBsubnetgroup"
  }
}
*/
