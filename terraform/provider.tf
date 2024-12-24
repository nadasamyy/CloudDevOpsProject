terraform {
  backend "s3" {
    bucket         = "finalprojectv"
    key            = "terraform/state"
    region         = "us-east-1"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.19.0"
    }
  }
}
