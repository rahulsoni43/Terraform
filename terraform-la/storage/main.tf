provider "aws" {
  region = var.aws_region
  secret_key = "eCbX7t30Ll5vvHgVk+GZJSZpVn4SzbgW7SlcUg1K"
  access_key = "AKIAVRPP7FFVQKTTYK5G"
}


resource "aws_s3_bucket" "las3" {
  bucket = "${var.project_name}-${random_id.s3id.dec}"
  acl = "private"
  force_destroy = true
}

resource "random_id" "s3id" {
   byte_length = 2
}
