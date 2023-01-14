module "tags" {
  source            = "fivexl/tag-generator/aws"
  version           = "2.0.0"
  prefix            = "cloud-gaming"
  terraform_managed = "1"
  terraform_state   = "unknown"
  environment_name  = "default"
  environment_type  = "core"
  data_owner        = "cloud-gaming"
  data_pci          = "0"
  data_phi          = "0"
  data_pii          = "0"
}