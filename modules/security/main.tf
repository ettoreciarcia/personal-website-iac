locals {
  application_name = var.tags["Application"]
  environment      = var.tags["Environment"]
}

//create iam user for github actions to deploy to s3 bucket and cloudfront 
resource "aws_iam_user" "github_actions" {
  name = "github-actions-"
}


//create iam policy to grant all priviles on a single bucket and invalidate CDN
resource "aws_iam_policy" "github_actions_policy" {
  name = "${local.application_name}--${local.environment}-github-actions-policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "${var.bucket_arn}",
        "${var.bucket_arn}/*"
      ],
      "Action": [
        "s3:*"
      ]
    },
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "cloudfront:CreateInvalidation",
      "Resource": "${var.cloudfront_distribution_arn}}"
    }
  ]
}
POLICY
}




