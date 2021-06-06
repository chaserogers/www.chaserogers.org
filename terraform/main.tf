terraform {
  required_version = "~> 0.14"

  backend "s3" {} # configured in config/backend.tfvars

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region

  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/TerraformRole"
  }
}

provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/TerraformRole"
  }
}

data "aws_route53_zone" "default" {
  name = var.domain_name
  private_zone = false
}

resource "aws_cloudfront_origin_access_identity" "primary" {
  comment = "Primary OAI used with cloudfront distros"
}
