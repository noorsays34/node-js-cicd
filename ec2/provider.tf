provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "nodejs-terraform-state-saishma-2026-001"
    key            = "nodejs-app/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}