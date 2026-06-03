variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_name" {
  default = "terraform-ec2"
}

variable "key_name" {
  description = "AWS Key Pair Name"
}