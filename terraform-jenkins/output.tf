output "public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "bucket-name" {
  value = aws_s3_bucket.jenkins-bucket.id
}
