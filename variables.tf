variable "application_name" {
  type        = string
  description = "Name of the application"
}

variable "environment" {
  type        = string
  description = "Environment of the application dev/test/prod"
}

variable "region" {
  type = string
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate to use for the CloudFront distribution"
}