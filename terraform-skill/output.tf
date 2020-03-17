output "Public_Ip" {
  value = join(", ", aws_instance.server.*.public_ip)
}

output "Instance_ID" {
  value = join(", ", aws_instance.server.*.id)
}

output "Project_Name" {
  value = aws_s3_bucket.bucket.id
}
