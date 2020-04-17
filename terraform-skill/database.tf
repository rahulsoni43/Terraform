/*resource "aws_security_group" "dbsg" {
  name = "DatabaseSG"
  vpc_id = aws_vpc.prodvpc.id

}

resource "aws_security_group_rule" "db-rule" {
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.dbsg.id
  source_security_group_id = aws_security_group.prodsg.id
}

resource "aws_security_group_rule" "app-rule" {
  type                     = "ingress"
  from_port                = "80"
  to_port                  = "80"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.dbsg.id
  source_security_group_id = aws_security_group.prodsg.id
}
*/
