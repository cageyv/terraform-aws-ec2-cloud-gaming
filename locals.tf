locals {
  vpc_azs_max = 1
  vpc_cidr    = "10.100.0.0/16"
  vpc_name    = "cloud-gaming"
  vpn_cidrs   = ["0.0.0.0/0"] #TODO: WARNING: This is a security risk. Only use this for testing. And/or use a VPN. 

  volume_size_for_games = 130 #GB
  instance_type         = "g4dn.xlarge"
  ec2_vcpu_max_quota    = 8

  custom_bucket_names = ["nvidia-gaming", "ec2-windows-nvidia-drivers"]
  is_instance_running = true  # `false` for stopped or `true` for running
  use_ec2_spot        = false # `false` for On-Demand or `true` for Spot
}