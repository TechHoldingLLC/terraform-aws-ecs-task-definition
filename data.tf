#################################
#  ecs-task-defination/data.tf  #
#################################

data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_kms_alias" "ssm" {
  name = var.ssm_kms_alias
}

locals {
  aws_partition   = data.aws_partition.current.partition
  account_id      = data.aws_caller_identity.current.account_id
  region          = data.aws_region.current.name
  ssm_kms_key_arn = data.aws_kms_alias.ssm.target_key_arn

  # For IAM permissions
  secret_environment_variables = flatten([
    for container_definition in var.container_definitions : [
      for secret in container_definition.secrets : {
        name      = secret.name
        valueFrom = secret.valueFrom
      }
    ]
  ])

  # A valueFrom is either an SSM path or a Secrets Manager ARN that may carry a :json-key:version-stage:version-id suffix IAM must not see.
  secretsmanager_secret_arns = distinct([
    for secret in local.secret_environment_variables :
    join(":", slice(split(":", secret["valueFrom"]), 0, 7))
    if startswith(secret["valueFrom"], "arn:${local.aws_partition}:secretsmanager:")
  ])

  ssm_parameter_arns = [
    for secret in local.secret_environment_variables :
    "arn:${local.aws_partition}:ssm:${local.region}:${local.account_id}:parameter${secret["valueFrom"]}"
    if !startswith(secret["valueFrom"], "arn:${local.aws_partition}:secretsmanager:")
  ]

  kms_key_arns = concat(
    length(local.ssm_parameter_arns) > 0 ? [local.ssm_kms_key_arn] : [],
    var.secrets_kms_key_arns
  )
}
