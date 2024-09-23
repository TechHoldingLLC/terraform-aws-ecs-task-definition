####################################
#  ecs-task-defination/outputs.tf  #
####################################

output "name" {
  value = aws_ecs_task_definition.task.family
}

output "arn" {
  value = aws_ecs_task_definition.task.arn
}

output "arn_without_revision" {
  value = aws_ecs_task_definition.task.arn_without_revision
}

output "revision" {
  value = aws_ecs_task_definition.task.revision
}

output "execution_role_arn" {
  value = aws_iam_role.ecs_task_execution.arn
}

output "execution_role_name" {
  value = aws_iam_role.ecs_task_execution.name
}

output "role_name" {
  value = aws_iam_role.task.name
}

output "role_arn" {
  value = aws_iam_role.task.arn
}