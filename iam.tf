# https://docs.aws.amazon.com/en_en/AWSEC2/latest/WindowsGuide/install-nvidia-driver.html#nvidia-driver-types
# nvidia-gaming.s3.amazonaws.com
data "aws_iam_policy_document" "ec2_s3_custom_bucket" {
  statement {
    sid    = "S3Read"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [for bucket in local.custom_bucket_names : "arn:aws:s3:::${bucket}/*"]
  }
  statement {
    sid    = "S3List"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [for bucket in local.custom_bucket_names : "arn:aws:s3:::${bucket}"]
  }
}

resource "aws_iam_policy" "ec2_s3_custom_bucket" {
  name   = "ec2_s3_custom_bucket"
  path   = "/"
  policy = data.aws_iam_policy_document.ec2_s3_custom_bucket.json
  tags   = module.tags.result
}


module "ec2_ssm_cw_basic" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.10.0"

  trusted_role_services   = ["ec2.amazonaws.com"]
  role_name               = "ec2_ssm_cw_basic"
  create_role             = true
  create_instance_profile = true
  role_requires_mfa       = false

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ec2-run-command.html
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",  # https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-iam-roles-for-cloudwatch-agent.html
    aws_iam_policy.ec2_s3_custom_bucket.arn,
  ]
}

module "ec2_key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.1"

  key_name           = "ec2"
  create_private_key = true
}

#WARNING: This file is managed by Terraform. Manual changes may be overwritten.
#WARNING: This is sensitive data. Do not commit it to version control.
#WARNING: This is security risk. Do not share it with anyone. Better to use Secrets Manager.
resource "local_sensitive_file" "ec2_key_pair" {
  content  = module.ec2_key_pair.private_key_pem
  filename = "${path.module}/ec2.pem"
}
