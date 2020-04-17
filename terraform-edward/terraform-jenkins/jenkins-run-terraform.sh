#!/bin/bash
set -ex
AWS_REGION="ap-south-1"
S3_BUCKET=`aws s3 ls --region $AWS_REGION |grep rahul |tail -n1 |cut -d ' ' -f3`
sed -i 's/terraform-state-xx70dpnh/'${S3_BUCKET}'/' s3.tf
sed -i 's/#//g' backend.tf
aws s3 cp s3://${S3_BUCKET}/amivar.tf amivar.tf --region $AWS_REGION
terraform init
terraform apply -auto-approve -var APP_INSTANCE_COUNT=1 -target aws_instance.app-instance
