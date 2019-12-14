provider "aws" {
  region = "${var.aws_region}"
}

resource "random_id" "tf_bucket_id"{
  byte_length = "2"
  count = "${var.number_of_instances}"
}

resource "aws_s3_bucket" "tf_code" {
  bucket = "${var.project_name}-${random_id.tf_bucket_id.*.dec[count.index]}"
  count = "${var.number_of_instances}"
  acl = "private"
  force_destroy = true
  tags = {
      name = "tf_bucket${count.index+1}"

  }
}
