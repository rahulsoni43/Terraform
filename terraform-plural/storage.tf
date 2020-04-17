/*
resource "aws_s3_bucket" "application" {
    bucket = "application-team"
    acl = "private"
    force_destroy = true

    policy = <<EOF
{
      "Version": "2012-10-17",
      "Id": "APPBUCKETPOLICY",
      "Statement": [
        {
          "Sid": "APPteam",
          "Effect": "Allow",
          "Principal": {
            "AWS": "${aws_iam_user.marry.arn}"
          },
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::application-team/*"
        },
        {
          "Sid": "Allowall",
          "Effect": "Allow",
          "Action": "s3:*",
          "Principal": {
            "AWS": "${aws_iam_user.sally.arn}"
          },
          "Resource": [
             "arn:aws:s3:::application-team",
             "arn:aws:s3:::application-team/*"
          ]
        }
      ]
}
EOF
}


resource "aws_s3_bucket" "networking" {
    bucket = "net-team"
    acl = "private"
    force_destroy = true

    policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "ALLNETteam",
          "Effect": "Allow",
          "Principal": {
            "AWS": "${aws_iam_user.sally.arn}"
          },
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::net-team/*"
        },
        {
          "Sid": "Allowall",
          "Effect": "Allow",
          "Action": "s3:*",
          "Principal": {
            "AWS": "${aws_iam_user.marry.arn}"
          },
          "Resource": [
             "arn:aws:s3:::net-team",
             "arn:aws:s3:::net-team/*"
          ]
        }
      ]
}
EOF
}
*/
resource "aws_iam_user" "sally" {
  name = "sally"
}

resource "aws_iam_user" "marry" {
  name = "marry"

}

resource "aws_iam_access_key" "marrykey" {
  user = aws_iam_user.marry.name
}

resource "aws_iam_access_key" "sallykey" {
  user = aws_iam_user.sally.name
}
/*
resource "aws_iam_user_policy" "marry" {
  name = "marry_policy"
  user = aws_iam_user.marry.name
  policy= <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": ["dynamodb:*"],
              "Resource": [
                  "${aws_dynamodb_table.terraform_statelock.arn}"
              ]
          }
     ]
}
EOF
}


resource "aws_iam_user_policy" "sally" {
  name = "sally_policy"
  user = aws_iam_user.sally.name
  policy= <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": ["dynamodb:*"],
              "Resource": [
                  "${aws_dynamodb_table.terraform_statelock.arn}"
              ]
          }
     ]
}
EOF
}
*/

resource "aws_iam_group" "rdsadmin" {
  name = "RDSAdmin"
}

resource "aws_iam_group_membership" "add-rdsadmin" {
  name = "add-rdsamdin"
  users = [
    aws_iam_user.sally.name
  ]

  group = aws_iam_group.rdsadmin.name
}


resource "aws_iam_policy_attachment" "rdsattach" {
  name       = "rdsattach-policy"
  groups     = [aws_iam_group.rdsadmin.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_policy_attachment" "ec2attach" {
  name       = "ec2attach-policy"
  groups     = [aws_iam_group.ec2admin.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group" "ec2admin" {
  name = "ec2-admin"
}

resource "aws_iam_group_membership" "ec2groupadmin" {
  name = "ec2group"
  users = [
    aws_iam_user.marry.name,
    aws_iam_user.sally.name
  ]

  group = aws_iam_group.ec2admin.name
}


resource "local_file" "aws_keys" {
  content  = file("awskey.tpl")
  filename = "~/.aws/credentials"

}
