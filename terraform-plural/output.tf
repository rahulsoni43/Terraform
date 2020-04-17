
output "sally-access-key" {
  value = aws_iam_access_key.sallykey.id
}

output "sally-secret-key" {
  value = aws_iam_access_key.sallykey.secret
}

output "marry-access-key" {
  value = aws_iam_access_key.marrykey.id
}

output "marry-secret-key" {
  value = aws_iam_access_key.marrykey.secret
}
