output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.web.public_dns
}

output "nginx_url" {
  description = "URL to access the NGINX welcome page"
  value       = "http://${aws_instance.web.public_ip}"
}
