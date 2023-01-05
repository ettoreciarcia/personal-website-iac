variable "tags" {
  type        = map(string)
  default     = {}
  description = "List tags to pass to resources"
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate to use for the CloudFront distribution"
}