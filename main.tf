
locals {
  common_tags = {
    Application = var.application_name
    Environment = var.environment
  }
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "hechaorganization"
    workspaces {
      name = "personal-website-infra"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = local.common_tags
  }
}

module "infrastructure" {
  source              = "./modules/infra"
  acm_certificate_arn = var.acm_certificate_arn
  domain_name         = var.domain_name
  tags                = local.common_tags
}


