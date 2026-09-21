##################################
#  container-definition/data.tf  #
##################################

data "aws_region" "current" {}

locals {
  # A value is either a Secrets Manager ARN or a path under parameter_path_prefix.
  secretsmanager_env_vars = { for name, value in var.secret_environment_variables : name => value if startswith(value, "arn:") }
  ssm_env_vars            = { for name, value in var.secret_environment_variables : name => value if !startswith(value, "arn:") }
}

data "aws_ssm_parameter" "secret_env_vars" {
  for_each = local.ssm_env_vars
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
    [for name, value in local.ssm_env_vars : {
      name      = name
      valueFrom = data.aws_ssm_parameter.secret_env_vars[name].name
    }],
    [for name, value in local.secretsmanager_env_vars : {
      name      = name
      valueFrom = value
    }]
  )
}