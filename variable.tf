variable "region" {
  description = "The AWS region to deploy in"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro"
}

