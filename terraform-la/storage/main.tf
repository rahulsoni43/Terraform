resource "aws_s3_bucket" "las3" {
  bucket = "${var.project_name}-${random_id.s3id.dec}"
  acl = "private"
  force_destroy = true
}

resource "random_id" "s3id" {
   byte_length = 2
}
