module "sg_rdp" {

  source  = "terraform-aws-modules/security-group/aws//modules/rdp"
  version = "4.0.0"

  name        = "sg_rdp"
  description = "Access to RDP"

  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = concat(local.vpn_cidrs)
  tags                = module.tags.result

}
