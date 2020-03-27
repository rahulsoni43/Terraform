#Data Source to get the list of available zone in the region

data aws_availability_zones "available" {}

# Provider Details
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

#IAM

resource "aws_iam_role" "s3_access" {
  name = "s3_access"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
  },
      "Effect": "Allow",
      "Sid": ""
      }
    ]
}
EOF
}
resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "s3_access"
  role = aws_iam_role.s3_access.name
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "s3-policy"
  role = aws_iam_role.s3_access.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "s3:*",
        "Resource": "*"
      }
    ]
}
EOF
}

resource "random_id" "s3id" {
  byte_length = 2
}

resource "aws_s3_bucket" "s3buck" {
  bucket        = "var.bucket-name-${random_id.s3id.dec}"
  acl           = "private"
  force_destroy = true
}
