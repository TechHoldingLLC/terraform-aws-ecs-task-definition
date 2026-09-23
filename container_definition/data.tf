##################################
#  container-definition/data.tf  #
##################################

data "aws_region" "current" {}

data "aws_ssm_parameter" "secret_env_vars" {
  for_each = var.secret_environment_variables
  name     = "${var.parameter_path_prefix}/${each.value}"
}

## Create map of "parameter_name => parameter_version" to detect the change of parameter's value
resource "null_resource" "parameter_version_check" {
  triggers = {
    ssm_versions = jsonencode(
      {
        for parameter in data.aws_ssm_parameter.secret_env_vars : parameter.name => parameter.version
      }
    )
  }
}

locals {
  region = data.aws_region.current.name

  environment_variables = flatten([
    for name, value in var.environment_variables : {
      name  = name
      value = value
    }
  ])
  secret_environment_variables = concat(
    [for name, value in var.secret_environment_variables : {
      name      = name
      valueFrom = data.aws_ssm_parameter.secret_env_vars[name].name
    }],
    # ECS reads one JSON key when the ARN carries a :key:version-stage:version-id suffix.
    [for name, secret in var.secretsmanager_environment_variables : {
      name      = name
      valueFrom = secret.json_key == null ? secret.secret_arn : "${secret.secret_arn}:${secret.json_key}::"
    }]
  )
}