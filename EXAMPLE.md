# ECS Task Definition
Below is an examples of calling this module.

Note: By default, network_mode is set to "awsvpc", command is set to null and kms alias is set to "alias/aws/ssm" in this module

## Create ECS Task Definition
```
module "ecs_task_definition" {
  source      = "./ecs-task-definition"
  name        = "demo-ecs-task-definition"
  image       = "demo-image"
  task_cpu    = 256
  task_memory = 512
  command     = "npm run start"
  port        = 80
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  Refer this doc for more information on health check https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ecs-taskdefinition-healthcheck.html
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
  secret_environment_variables = {
    SECRET = "path/to/ssm/variable"
  }
  cloudwatch_log_retention_in_days = 30
}
```

