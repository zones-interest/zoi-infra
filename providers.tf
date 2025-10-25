terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket = "state-bucket360691803169"
    key    = "socpro/terraform.tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {
  region                   = "eu-west-2"
  shared_credentials_files = ["../.aws/credentials"]
  shared_config_files      = ["../.aws/config"]
}