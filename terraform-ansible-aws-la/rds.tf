/*resource "aws_db_instance" "rds" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = var.db_instance_name
  name                 = var.db_name
  username             = var.db_user
  password             = var.db_password
  skip_final_snapshot  = true
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = "aws_db_subnet_group.rds_sub_group.id"
}
*/
