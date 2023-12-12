######################################
#  ecs-task-defination/variables.tf  #
######################################

variable "cloudwatch_log_retention_in_days" {
  description = "Retention period for cloudwatch log group"
  type        = number
}

variable "command" {
  description = "Task command"
  type        = string
  default     = null
}

variable "image" {
  description = "ECR image"
  type        = string
}

variable "name" {
  description = "ECS task definition name"
  type        = string
}

variable "environment_variables" {
  description = "ECS secrets environment variables"
  type        = map(string)
}

variable "network_mode" {
  description = "Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host."
  type        = string
  default     = "awsvpc"
}

variable "port" {
  description = "ECS container port"
  type        = number
  default     = 0
}

variable "requires_compatibilities" {
  description = " A set of launch types required by the task. The valid values are EC2 and FARGATE."
  type        = list(string)
}

variable "secret_environment_variables" {
  description = "ECS secrets environment variables"
  type        = map(string)
}

variable "ssm_kms_alias" {
  description = "SSM kms key alias"
  type        = string
  default     = "alias/aws/ssm"
}

variable "task_cpu" {
  description = "ECS fargate task cpu"
  type        = number
}

variable "task_memory" {
  description = "ECS fargate task memory"
  type        = number
}

variable "health_check" {
  description = "task definition health check"
  default     = null
}