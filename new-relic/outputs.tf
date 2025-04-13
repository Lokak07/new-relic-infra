output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "azs" {
  description = "List of Availability Zones used"
  value       = module.vpc.azs
}

output "default_security_group_id" {
  description = "ID of the default security group created in the VPC"
  value       = module.vpc.default_security_group_id
}

output "tags" {
  description = "Tags applied to the VPC and its resources"
  value       = var.tags
}
