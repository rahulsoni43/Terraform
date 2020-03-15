resource "aws_subnet" "dmz_subnet" {
  count = 2
  vpc_id = aws_vpc.prodvpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.dmz_cidrs[count.index]

  tags = {
    Name = "dmz_subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = 2
  vpc_id = aws_vpc.prodvpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.private_cidrs[count.index]

  tags = {
    Name = "private_subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "public_subnet" {
  count = 2
  map_public_ip_on_launch = "true"
  vpc_id = aws_vpc.prodvpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.public_cidrs[count.index]

  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}
