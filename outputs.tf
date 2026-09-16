output "vpc_id" {
  description = "ID of the project VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the project VPC"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private application subnet IDs"
  value       = module.vpc.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Private database subnet IDs"
  value       = module.vpc.private_db_subnet_ids
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = module.vpc.nat_gateway_id
}
output "web_security_group_id" {
  description = "ID of the Web Security Group"
  value       = module.security_groups.web_security_group_id
}

output "app_security_group_id" {
  description = "ID of the Application Security Group"
  value       = module.security_groups.app_security_group_id
}

output "db_security_group_id" {
  description = "ID of the Database Security Group"
  value       = module.security_groups.db_security_group_id
}
output "web_instance_id" {
  description = "ID of the Web EC2 instance"
  value       = module.ec2.web_instance_id
}

output "web_public_ip" {
  description = "Public IP address of the Web EC2 instance"
  value       = module.ec2.web_public_ip
}

output "web_private_ip" {
  description = "Private IP address of the Web EC2 instance"
  value       = module.ec2.web_private_ip
}

output "app_instance_ids" {
  description = "IDs of the Application EC2 instances"
  value       = module.ec2.app_instance_ids
}

output "app_private_ips" {
  description = "Private IP addresses of the Application EC2 instances"
  value       = module.ec2.app_private_ips
}
output "db_instance_id" {
  description = "RDS instance ID"
  value       = module.rds.db_instance_id
}

output "db_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = module.rds.db_endpoint
}

output "db_port" {
  description = "RDS PostgreSQL port"
  value       = module.rds.db_port
}

output "db_name" {
  description = "Database name"
  value       = module.rds.db_name
}
