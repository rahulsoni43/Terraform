resource "aws_iam_role" "jenkins-role" {
  name = "jenkins-role"

  assume_role_policy = <<-EOF
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

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins_profile"
  role = aws_iam_role.jenkins-role.name
}

resource "aws_iam_role_policy" "admin-policy" {
  name = "Jenkins-Policy"
  role = aws_iam_role.jenkins-role.name

  policy = <<-EOF
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
   ]
  }
  EOF
}
