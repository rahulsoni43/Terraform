output "server_id" {
  value = join(", ", aws_instance.server.*.id)
}
output "server_ip" {
  value = join(", ", aws_instance.server.*.public_ip)
}
