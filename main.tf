################################################
#  ecs-task-defination/ecs-task-defination.tf  #
################################################

# resource "aws_cloudwatch_log_group" "ecs_task" {
#   name              = "/aws/ecs/${var.name}"
#   retention_in_days = var.cloudwatch_log_retention_in_days
# }

resource "aws_ecs_task_definition" "task" {
  family                   = var.name
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.task.arn
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions    = jsonencode(var.container_definitions)

  ## The resource will be restarted if null resource restarts 
  # lifecycle {
  #   replace_triggered_by = [
  #     null_resource.parameter_version_check
  #   ]
  # }
}
