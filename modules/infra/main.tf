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

resource "aws_s3_bucket_website_configuration" "bucket_website" {
  bucket = aws_s3_bucket.website.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.website.bucket}/*"
        }
    ]
}
POLICY
}

resource "aws_cloudfront_distribution" "static_website" {
  enabled = true
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name #"${aws_s3_bucket.website.bucket}.s3-website-${var.region}.amazonaws.com}" #bucket_regional_domain_name does not contain the region
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
