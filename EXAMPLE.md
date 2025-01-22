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

