data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs                = slice(data.aws_availability_zones.available.names, 0, tonumber(local.vpc_azs_max))
  vpc_subnets        = cidrsubnets(local.vpc_cidr, 3, 3, 3, 3, 3, 3, 3, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8)
  vpc_public_subnets = [for i in range(local.vpc_azs_max) : local.vpc_subnets[i + 1]] # ["10.68.32.0/19", "10.68.64.0/19", "10.68.96.0/19"]
}

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "3.11.0"
  name                 = local.vpc_name
  cidr                 = local.vpc_cidr
  azs                  = local.azs
  public_subnets       = local.vpc_public_subnets
  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway             = false
  enable_vpn_gateway             = false
  manage_default_security_group  = true
  default_security_group_name    = "default-deny"
  default_security_group_ingress = []
  default_security_group_egress  = []
  vpc_tags = {
    VPC_CODE_DO_NOT_DELETE = md5(format("%s-%s-%s", local.vpc_name, data.aws_caller_identity.current.account_id, data.aws_region.current.name))
  }
  tags = module.tags.result
}

