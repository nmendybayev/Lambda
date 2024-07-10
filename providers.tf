# Configure the AWS Provider:

provider "aws" {
  region = "us-east-1"
}

# Configure Terraform local backend:

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "local" {
    path = "terraform.tfstate"
  }
}