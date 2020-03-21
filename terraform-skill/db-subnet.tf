/*resource "aws_db_subnet_group" "privatedb" {
  name       = "dbsubnet"
  subnet_ids = aws_subnet.private_subnet.*.id

  tags = {
    Name = "DBsubnetgroup"
  }
}


resource "aws_db_instance" "rds" {
  count = 2
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.privatedb.name
  multi_az = true

  tags = {
    Name = "RDS_${count.index + 1}"
}
}
*/
