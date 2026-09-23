#####################################
#  container-definition/outputs.tf  #
#####################################

################################################################################
# Container Definition
################################################################################

output "container_definition" {
  description = "Container definition"
  value       = local.container_definition
}

output "container_definition_name" {
  description = "Name of the container definition"
  value       = local.container_definition.name
}

################################################################################
# CloudWatch Log Group
################################################################################

output "cloudwatch_log_group_name" {
  description = "Name of CloudWatch log group created"
  value       = try(aws_cloudwatch_log_group.this[0].name, null)
}

output "cloudwatch_log_group_arn" {
  description = "ARN of CloudWatch log group created"
  value       = try(aws_cloudwatch_log_group.this[0].arn, null)
}

output "secretsmanager_secret_arns" {
  description = "Bare Secrets Manager ARNs referenced by this container, for the execution role policy"
  value       = distinct([for secret in var.secretsmanager_environment_variables : secret.secret_arn])
}
