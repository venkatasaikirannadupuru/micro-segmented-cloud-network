output "web_instance_id" {
  description = "ID of the Web EC2 instance"
  value       = aws_instance.web.id
}

output "web_public_ip" {
  description = "Public IP address of the Web EC2 instance"
  value       = aws_instance.web.public_ip
}

output "web_private_ip" {
  description = "Private IP address of the Web EC2 instance"
  value       = aws_instance.web.private_ip
}

output "app_instance_ids" {
  description = "IDs of the Application EC2 instances"
  value       = aws_instance.app[*].id
}

output "app_private_ips" {
  description = "Private IP addresses of the Application EC2 instances"
  value       = aws_instance.app[*].private_ip
}
