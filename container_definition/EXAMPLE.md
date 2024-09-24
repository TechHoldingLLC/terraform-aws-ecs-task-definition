# ECS Container Definition
Below is an examples of calling this module.

Note: By default, cloudwatch logging and log group creation is enabled,command is set to null and kms alias is set to "alias/aws/ssm" in this module.

## Create ECS Container Definition
```
module "ecs_container_definition" {
  source = "git::https://github.com/TechHoldingLLC/terraform-aws-ecs-task-definition.git//container_definition"

  cpu    = 256
  memory = 512

  name  = "demo-ecs-container-definition"
  image = "demo-image"

  port_mappings = [
    {
      name          = "demo-ecs-container-definition-api"
      hostPort      = 3000
      protocol      = "tcp"
      containerPort = 3000
    }
  ]
  command = "npm start"
  # Refer this doc for more information on health check https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ecs-taskdefinition-healthcheck.html
  health_check = {
    command     = ["CMD-SHELL", "curl -f http://localhost:${#PORT}${#HEALTH_CHECK_PATH} || exit 1"]
    interval    = 30
    timeout     = 5
    retries     = 2
    startPeriod = 0
  }
  environment_variables = {
    TEST = "1"
    FOO = "BAR"
  }
  parameter_path_prefix = "/project/env"
  secret_environment_variables = {
    SECRET = "remaining_path/to/ssm/variable"
  }
  cloudwatch_log_retention_in_days = 30

  providers = {
    aws = aws
  }
}
```
