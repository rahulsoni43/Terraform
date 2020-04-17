resource "aws_ecr_repository" "app" {
  name = "aws-repo"
}

output "aws_ecr_url" {
  value = aws_ecr_repository.app.repository_url
}
