terraform {
  required_version = "1.3.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
