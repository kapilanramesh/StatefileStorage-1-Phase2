# --------------------
# Backend config
# --------------------
terraform {
  backend "s3" {
    bucket         = var.s3_bucket_name
    key            = "ec2/${var.environment}/terraform.tfstate"
    region         = var.region
    dynamodb_table = var.dynamodb_table_name
    encrypt        = true
  }
}

# --------------------
# AWS Provider
# --------------------
provider "aws" {
  region = var.region
}

# --------------------
# Get default VPC
# --------------------
data "aws_vpc" "default" {
  default = true
}

# --------------------
# Security Group
# --------------------
resource "aws_security_group" "nginx_sg" {
  name        = "nginx-sg"
  description = "Allow SSH and HTTP access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginx-security-group"
  }
}

# --------------------
# Jenkins key pair
# --------------------
resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins-key"
  public_key = file("/var/lib/jenkins/.ssh/id_rsa.pub")
}

# --------------------
# Launch EC2
# --------------------
resource "aws_instance" "web" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.jenkins_key.key_name
  security_groups = [aws_security_group.nginx_sg.name]

  tags = {
    Name = "nginx-server"
  }
}

# --------------------
# Optional: Outputs for dynamic inventory
# --------------------
output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.web.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of EC2 instance"
  value       = aws_instance.web.public_dns
}

output "nginx_url" {
  description = "URL to access the NGINX welcome page"
  value       = "http://${aws_instance.web.public_ip}"
}
