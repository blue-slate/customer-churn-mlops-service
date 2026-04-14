terraform {
  required_version = ">= 1.14.0"
  backend "s3" {
    region       = "us-west-2"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.40"
    }
  }
}

provider "aws" {
  region = var.aws_region
}