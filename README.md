# terraform-aws-ec2-cloud-gaming

# Before running Terraform
- Subscribe to the NVIDIA Gaming PC - Windows Server 2019 AMI on the AWS Marketplace
- Increase the following service quotas:
  - EC2 - General Purpose vCPUs running On-Demand (L-DB2E81BA: 8 )
  - EC2 - General Purpose vCPUs running Spot Instances (L-3819A6DF: 8)

# NVIDIA Gaming PC - Windows Server 2019
https://aws.amazon.com/marketplace/pp/prodview-xrrke4dwueqv6 

# Update NVIDIA drivers script
```ps1
      $Bucket = "nvidia-gaming"
      $KeyPrefix = "windows/latest"
      $LocalPath = "$ENV:UserProfile\Downloads\NVIDIA"
      $Objects = Get-S3Object -BucketName $Bucket -KeyPrefix $KeyPrefix -Region us-east-1
      New-Item -Path $LocalPath -ItemType "directory"
      foreach ($Object in $Objects) {
          $LocalFileName = $Object.Key
          if ($LocalFileName -ne '' -and $Object.Size -ne 0) {
              $LocalFilePath = Join-Path $LocalPath $LocalFileName
              Copy-S3Object -BucketName $Bucket -Key $Object.Key -LocalFile $LocalFilePath -Region us-east-1
          }
      }
```

# VPN Recommendations
- https://github.com/trailofbits/algo (Algo VPN)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.49.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.2.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_key_pair"></a> [ec2\_key\_pair](#module\_ec2\_key\_pair) | terraform-aws-modules/key-pair/aws | 2.0.1 |
| <a name="module_ec2_ssm_cw_basic"></a> [ec2\_ssm\_cw\_basic](#module\_ec2\_ssm\_cw\_basic) | terraform-aws-modules/iam/aws//modules/iam-assumable-role | 5.10.0 |
| <a name="module_sg_rdp"></a> [sg\_rdp](#module\_sg\_rdp) | terraform-aws-modules/security-group/aws//modules/rdp | 4.0.0 |
| <a name="module_tags"></a> [tags](#module\_tags) | fivexl/tag-generator/aws | 2.0.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.11.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ebs_volume.games](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_ec2_instance_state.cloudgaming](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_instance_state) | resource |
| [aws_iam_policy.ec2_s3_custom_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_instance.cloudgaming](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_launch_template.cloudgaming](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_servicequotas_service_quota.ec2_g_vt_running_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicequotas_service_quota) | resource |
| [aws_servicequotas_service_quota.ec2_g_vt_spot_instance_requests](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicequotas_service_quota) | resource |
| [aws_volume_attachment.games](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [local_sensitive_file.ec2_key_pair](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [aws_ami.nvidia_gamingpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.parsec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.windows](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ec2_s3_custom_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->