resource "aws_dynamodb_table" "terraform_statelock" {
  name           = var.dynamodb_table
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}

data "template_file" "app" {
  template = file("templates/app.tpl")

  vars = {
    s3_bucket   = var.aws_application_bucket
    full_access = aws_iam_user.sally.arn
    read_access = aws_iam_user.marry.arn
  }
}

data "template_file" "net" {
  template = file("templates/app.tpl")

  vars = {
    s3_bucket   = var.aws_networking_bucket
    full_access = aws_iam_user.marry.arn
    read_access = aws_iam_user.sally.arn
  }
}

data "template_file" "user" {
  template = file("templates/user.tpl")

  vars = {
    dynamodb = aws_dynamodb_table.terraform_statelock.arn
  }
}

resource "aws_s3_bucket" "application" {
  bucket        = var.aws_application_bucket
  acl           = "private"
  force_destroy = true
  policy        = data.template_file.app.rendered
}

resource "aws_s3_bucket" "networking" {
  bucket        = var.aws_networking_bucket
  acl           = "private"
  force_destroy = true
  policy        = data.template_file.net.rendered
}

resource "aws_iam_user_policy" "marry" {
  name   = "marry_policy"
  user   = aws_iam_user.marry.name
  policy = data.template_file.user.rendered
}

resource "aws_iam_user_policy" "sally" {
  name   = "sally_policy"
  user   = aws_iam_user.marry.name
  policy = data.template_file.user.rendered
}
