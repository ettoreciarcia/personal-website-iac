locals {
  application_name = var.tags["Application"]
  environment      = var.tags["Environment"]
}


resource aws_s3_bucket website {
  bucket = "${local.application_name}-ciarcia"
  tags = var.tags
}