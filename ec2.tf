resource "aws_instance" "cloudgaming" {
  instance_type = local.instance_type
  launch_template {
    id      = aws_launch_template.cloudgaming.id
    version = "$Latest"
  }
  get_password_data = true
  root_block_device {
    volume_size           = 35
    volume_type           = "gp3"
    tags                  = merge(module.tags.result, { Name = "cloudgaming" })
    delete_on_termination = true
  }
  tags = merge(module.tags.result, {
    Name = "cloudgaming"
  })
}

resource "aws_ec2_instance_state" "cloudgaming" {
  instance_id = aws_instance.cloudgaming.id
  state       = local.is_instance_running ? "running" : "stopped"
}

#create volume for games. It will cost ~14$ per month
resource "aws_ebs_volume" "games" {
  availability_zone = module.vpc.azs[0]
  size              = local.volume_size_for_games
  type              = "gp3"
  tags = merge(module.tags.result, {
    Name = "cloudgaming"
  })
}

resource "aws_volume_attachment" "games" {
  device_name = "xvdf"
  volume_id   = aws_ebs_volume.games.id
  instance_id = aws_instance.cloudgaming.id

  stop_instance_before_detaching = true
}
