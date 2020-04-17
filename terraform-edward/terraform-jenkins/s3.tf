resource "aws_s3_bucket" "jenkins-bucket" {
    bucket = "${var.bucket}-${random_id.s3id.dec}"
    acl = "private"
}

resource "random_id" "s3id" {
  byte_length = 2
}
