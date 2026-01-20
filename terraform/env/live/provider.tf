terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.14.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.11.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.13.0"
    }
  }

  backend "s3" {
    bucket  = "submission-state-bucket"
    key     = "infra.tfstate"
    region  = "ap-south-1"
    encrypt = true
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

provider "kubectl" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}






