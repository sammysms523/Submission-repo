terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.14.1"
    }
  }

  backend "s3" {
    bucket         = "submission-state-bucket"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }

  required_version = "~> 1.11.1"
}
 
provider "aws" {
  region = var.home_region

  default_tags {
    tags = {
        team = "ivanti submission"
    }
  }
}