output "VPCID" {
  value = aws_vpc.lavpc.id
}

output "default_route_table_id" {
  value = aws_default_route_table.privatert.default_route_table_id
}

output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
}

output "security_groups" {
  value = aws_security_group.lasg.id
}

output "subnet_ips" {
  value = aws_subnet.public_subnet.*.cidr_block
}
