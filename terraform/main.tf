
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = var.profile
  region  = var.region

  default_tags {
    tags = {
      "Environment" = "D1"
      "project" : "terraform"
    }
  }
}
