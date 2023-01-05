
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

module infrastructure {
  source = "./modules/infra"
  tags = local.common_tags
}


