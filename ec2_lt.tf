data "aws_ami" "parsec" {
  most_recent = true
  owners      = ["aws-marketplace"]
  filter {
    name = "platform"
    values = [
      "windows",
    ]
  }
  filter {
    name = "product-code"
    values = [
      "31c5ka6yx7n3oiv7btju0j6ry", # Parsec for Teams - BYOL NVIDIA GPU. It cost ~35$ per month, but allow us to do full automatization https://support.parsec.app/hc/en-us/articles/4408962860813
    ]
  }
}

data "aws_ami" "nvidia_gamingpc" {
  most_recent = true
  owners      = ["aws-marketplace"]
  filter {
    name = "platform"
    values = [
      "windows",
    ]
  }
  filter {
    name = "product-code"
    values = [
      "eg29gsv7egae1ip4ff8by2vjx", # NVIDIA Gaming PC - Windows Server 2019
    ]
  }
}

data "aws_ami" "windows" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base*"]
  }
}

resource "aws_launch_template" "cloudgaming" {
  name                   = "cloudgaming"
  description            = "CloudGaming instance"
  update_default_version = true
  image_id               = data.aws_ami.nvidia_gamingpc.image_id
  instance_type          = local.instance_type
  key_name               = module.ec2_key_pair.key_pair_name
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [module.sg_rdp.security_group_id, module.sg_parsec.security_group_id]
    subnet_id                   = module.vpc.public_subnets[0]
  }
  iam_instance_profile {
    arn = module.ec2_ssm_cw_basic.iam_instance_profile_arn
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional" # Some of scrips doesn't work with required
    http_put_response_hop_limit = 1
    instance_metadata_tags      = true
  }
  monitoring {
    enabled = false
  }
  dynamic "instance_market_options" {
    for_each = local.use_ec2_spot ? { enabled = true } : {}
    content {
      market_type = "spot"
      spot_options {
        spot_instance_type             = "persistent"
        instance_interruption_behavior = "stop"
      }
    }
  }
  tags = module.tags.result
}

