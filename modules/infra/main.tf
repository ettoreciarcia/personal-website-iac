locals {
  application_name = var.tags["Application"]
  environment      = var.tags["Environment"]
}


resource "aws_s3_bucket" "website" {
  bucket = "${local.application_name}-ciarcia"
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.website.id
  acl    = "public-read"
}

resource "aws_cloudfront_distribution" "static_website" {
  enabled = true
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.website.bucket
  }

  aliases = [var.domain_name]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.website.bucket

    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = false
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

# resource "aws_acm_certificate" "acm_certificate" {
#   domain_name       = var.domain_name
#   validation_method = "DNS"
# }

# # Wait for the certificate to be issued
# resource "aws_acm_certificate_validation" "certificate_validation" {
#   certificate_arn = aws_acm_certificate.acm_certificate.arn
#   validation_record_fqdns = [aws_route53_record.aws_route53_record.fqdn]
# }

# # Create a Route53 record for the certificate validation
# resource "aws_route53_record" "aws_route53_record" {
#   name    = aws_acm_certificate_validation.certificate_validation.resource_record_name
#   type    = aws_acm_certificate_validation.certificate_validation.resource_record_type
#   zone_id = "${var.route53_zone_id}"
#   records = [aws_acm_certificate_validation.certificate_validation.resource_record_value]
#   ttl     = 60

#   depends_on = [aws_acm_certificate.acm_certificate]

# }