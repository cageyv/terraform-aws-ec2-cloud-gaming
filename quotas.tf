# Running On-Demand G and VT instances
# Maximum number of vCPUs assigned to the Running On-Demand G and VT instances.
resource "aws_servicequotas_service_quota" "ec2_g_vt_running_on_demand" {
  quota_code   = "L-DB2E81BA"
  service_code = "ec2"
  value        = local.ec2_vcpu_max_quota
}

# All G and VT Spot Instance Requests
# The maximum number of vCPUs for all running or requested G and VT Spot Instances per Region
resource "aws_servicequotas_service_quota" "ec2_g_vt_spot_instance_requests" {
  quota_code   = "L-3819A6DF"
  service_code = "ec2"
  value        = local.ec2_vcpu_max_quota
}
