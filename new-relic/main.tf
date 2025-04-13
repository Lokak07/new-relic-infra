module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.name
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  enable_vpn_gateway   = var.enable_vpn_gateway

  manage_default_security_group  = var.manage_default_security_group
  default_security_group_ingress = var.default_security_group_ingress
  default_security_group_egress  = var.default_security_group_egress

  enable_flow_log                      = var.enable_flow_log
  create_flow_log_cloudwatch_iam_role  = var.create_flow_log_cloudwatch_iam_role
  create_flow_log_cloudwatch_log_group = var.create_flow_log_cloudwatch_log_group
  tags                                 = var.tags
}

# ec2 module

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = var.instance_name

  instance_type = var.instance_type
  key_name      = var.key_name
  monitoring    = var.monitoring
  vpc_security_group_ids = length(var.security_group) > 0 ? var.security_group : [
    module.security-group_https-443.security_group_id,
    module.http_80_security_group.security_group_id,
    module.ssh_security_group.security_group_id
  ]

  depends_on = [
    module.security-group_https-443,
    module.http_80_security_group,
    module.ssh_security_group,
    module.vpc
  ]

  ami       = var.ami_id
  subnet_id = var.subnet_id != "" ? var.subnet_id : module.vpc.public_subnets[0]
  tags      = var.tags
}

# security group modules

# sg for 443

module "security-group_https-443" {
  source              = "terraform-aws-modules/security-group/aws//modules/https-443"
  version             = "~> 5.0"
  name                = var.sg_443_name
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"] # insert the 2 required variables here
}

module "http_80_security_group" {
  source              = "terraform-aws-modules/security-group/aws//modules/http-80"
  version             = "~> 5.0"
  name                = var.sg_80_name
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "ssh_security_group" {
  source              = "terraform-aws-modules/security-group/aws//modules/ssh"
  version             = "~> 5.0"
  name                = var.sg_22_name
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  # omitted...
}