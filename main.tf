terraform {
  backend "s3" {
    bucket         = "my-terraform-state-dev"
    key            = "env/dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks-dev"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name        = "WebServer"
    Environment = var.environment
  }
}
