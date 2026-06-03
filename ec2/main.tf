# Default VPC
data "aws_vpc" "default" {
  default = true
}

# Default Subnet (pick first one)
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# Security Group
resource "aws_security_group" "web_sg_saishma" {
  name        = "web-sg-saishma"
  description = "Allow HTTP and SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  #cidr_blocks = ["YOUR_IP/32"] You can your ip through this command "curl -4 ifconfig.me"
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type         = var.instance_type
  subnet_id             = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.web_sg_saishma.id]
#  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  associate_public_ip_address = true

  key_name   = var.key_name
  #key_name = "saishma-ec2-key"

  tags = {
    Name = var.instance_name
  }
  user_data = <<-EOF
              #!/bin/bash
              #hbh

              dnf update -y

              # Install Node.js 20
              curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -

              dnf install -y nodejs git nginx

              # Install PM2
              npm install -g pm2

              # Create application directory
              mkdir -p /home/ec2-user/nodeapp

              chown -R ec2-user:ec2-user /home/ec2-user/nodeapp

              # Start nginx
              systemctl enable nginx
              systemctl start nginx
              EOF
}
