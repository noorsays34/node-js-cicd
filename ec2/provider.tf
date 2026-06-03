provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = ""
    key            = "terraform.tfstate"
    region         = "ap-south-1"
  }
}