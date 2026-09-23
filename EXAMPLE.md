# ECS Task Definition
Below is an examples of calling this module.

Note: By default, network_mode is set to "awsvpc", command is set to null and kms alias is set to "alias/aws/ssm" in this module

## Create ECS Task Definition
```
module "ecs_task_definition" {
  source      = "git::https://github.com/TechHoldingLLC/terraform-aws-ecs-task-definition.git?ref=v1.0.3"

  name        = "demo-ecs-task-definition"
  task_cpu    = 256
  task_memory = 512

  container_definitions = [module.con_def_1.container_definition, module.con_def_2.container_definition]
}
```

## Create ECS Task Definition with specified runtime platform
If `runtime_platform` variable is not passed default os will be `LINUX` and architecture will be `X86_64`
```
module "ecs_task_definition" {
  source      = "git::https://github.com/TechHoldingLLC/terraform-aws-ecs-task-definition.git?ref=v1.0.8"

  name        = "demo-ecs-task-definition"
  task_cpu    = 256
  task_memory = 512

  container_definitions = [module.con_def_1.container_definition, module.con_def_2.container_definition]

  #If variable is not passed default os will be `LINUX` and architecture will be `X86_64`
  runtime_platform = {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}
```

## Create ECS Task Definition reading Secrets Manager secrets
The container names the secrets; the task definition needs their ARNs so the execution role can
read them, and the KMS key ARNs if they are encrypted with a customer managed key.
```
module "con_def" {
  source = "git::https://github.com/TechHoldingLLC/terraform-aws-ecs-task-definition.git//container_definition?ref=v1.1.0"

  name  = "api"
  image = var.api_image

  secretsmanager_environment_variables = {
    DB_USER     = { secret_arn = aws_secretsmanager_secret.db.arn, json_key = "username" }
    DB_PASSWORD = { secret_arn = aws_secretsmanager_secret.db.arn, json_key = "password" }
  }
}

module "ecs_task_definition" {
  source = "git::https://github.com/TechHoldingLLC/terraform-aws-ecs-task-definition.git?ref=v1.1.0"

  name        = "demo-ecs-task-definition"
  task_cpu    = 256
  task_memory = 512

  container_definitions = [module.con_def.container_definition]

  secretsmanager_secret_arns = module.con_def.secretsmanager_secret_arns
  secrets_kms_key_arns       = [aws_kms_key.secrets.arn]
}
```
Selecting a json_key needs Fargate platform version 1.4.0 or later. Omit it to inject the whole
secret value.
