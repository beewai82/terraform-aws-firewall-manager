terraform {
  required_version = "~> 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0"
    }
  }
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "waf-regional/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}

provider "aws" {
  region = var.aws_region
}

# Target the security group account only
locals {
  account_id        = data.aws_caller_identity.current.account_id
  deployment_region = var.aws_region
  environment       = var.environment
}

data "aws_caller_identity" "current" {}