################################################
#  ecs-task-defination/ecs-task-defination.tf  #
################################################

resource "aws_cloudwatch_log_group" "ecs_task" {
  name              = "/aws/ecs/${var.name}"
  retention_in_days = var.cloudwatch_log_retention_in_days
}

resource "aws_ecs_task_definition" "task" {
  family                   = var.name
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.task.arn
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions    = <<TASK_DEFINITION
    [
      {
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = "${aws_cloudwatch_log_group.ecs_task.name}"
            awslogs-region        = "${local.region}"
            awslogs-stream-prefix = "ecs"
          }
        },
        name        = "${var.name}"
        image       = "${var.image}"
        healthcheck = "${var.health_check}"
        portMappings = "${var.port}" > 0 ? [
          {
            hostPort      = "${var.port}"
            protocol      = "tcp"
            containerPort = "${var.port}"
          }
        ] : []
        environment = "${local.environment_variables}"
        secrets     = ${jsonencode(local.secret_environment_variables)}
        command     = "${length(var.command)} > 0" ? ["sh", "-c", "${var.command}"] : null
      }
    ]
  TASK_DEFINITION
}