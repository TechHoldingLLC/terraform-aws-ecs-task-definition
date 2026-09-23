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
  region          = data.aws_region.current.region
  ssm_kms_key_arn = data.aws_kms_alias.ssm.target_key_arn

  # Every secret each container reads, as the execution role has to be granted all of them.
  secret_sources = flatten([
    for container_definition in var.container_definitions :
    [for secret in try(container_definition.secrets, []) : secret.valueFrom]
  ])

  secretsmanager_prefix = "arn:${local.aws_partition}:secretsmanager:"

  # A valueFrom carries a :key:version-stage:version-id suffix that IAM must not see.
  secretsmanager_secret_arns = distinct([
    for source in local.secret_sources :
    join(":", slice(split(":", source), 0, 7))
    if startswith(source, local.secretsmanager_prefix)
  ])

  # ECS stores a bare parameter name in valueFrom, but IAM needs the full ARN.
  ssm_parameter_arns = distinct([
    for source in local.secret_sources :
    "arn:${local.aws_partition}:ssm:${local.region}:${local.account_id}:parameter${source}"
    if !startswith(source, local.secretsmanager_prefix)
  ])

  kms_key_arns = distinct(concat(
    length(local.ssm_parameter_arns) > 0 ? [local.ssm_kms_key_arn] : [],
    var.secrets_kms_key_arns
  ))
}
