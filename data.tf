#################################
#  ecs-task-defination/data.tf  #
#################################

data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_kms_alias" "ssm" {
  name = var.ssm_kms_alias
}

data "aws_ssm_parameter" "ssm_secret" {
  for_each = var.secret_environment_variables
  name     = "${var.parameter_path_prefix}/${each.value}"
}

resource "null_resource" "ssm_version_check" {
  triggers = {
    ssm_versions = join("", [for s in data.aws_ssm_parameter.ssm_secret : s.version])
  }
}

locals {
  aws_partition   = data.aws_partition.current.partition
  account_id      = data.aws_caller_identity.current.account_id
  region          = data.aws_region.current.name
  ssm_kms_key_arn = data.aws_kms_alias.ssm.target_key_arn
  # ssm_versions_hash = sha256(join(",", [for s in data.aws_ssm_parameter.ssm_secret : s.version]))

  environment_variables = flatten([
    for name, value in var.environment_variables : {
      name  = name
      value = value
    }
  ])
  secret_environment_variables = flatten([
    for name, valueFrom in var.secret_environment_variables : {
      name      = name
      valueFrom = data.aws_ssm_parameter.ssm_secret[name].name
    }
  ])
}
