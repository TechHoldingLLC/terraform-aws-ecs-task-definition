######################################
#  ecs-task-defination/variables.tf  #
######################################

# variable "cloudwatch_log_retention_in_days" {
#   description = "Retention period for cloudwatch log group"
#   type        = number
# }

# variable "command" {
#   description = "Task command"
#   type        = string
#   default     = ""
# }

# variable "parameter_path_prefix" {
#   description = "Path prefix for SSM parameter"
#   type        = string
#   default     = ""
# }

# variable "image" {
#   description = "ECR image"
#   type        = string
# }

variable "name" {
  description = "ECS task definition name"
  type        = string
}

# variable "environment_variables" {
#   description = "ECS secrets environment variables"
#   type        = map(string)
#   default     = {}
# }

variable "network_mode" {
  description = "Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host."
  type        = string
  default     = "awsvpc"
}

# variable "port" {
#   description = "ECS container port"
#   type        = number
#   default     = 0
# }

variable "requires_compatibilities" {
  description = " A set of launch types required by the task. The valid values are EC2 and FARGATE."
  type        = list(string)
  default     = ["FARGATE"]
}

# variable "secret_environment_variables" {
#   description = "ECS secrets environment variables"
#   type        = map(string)
#   default     = {}
# }

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

# variable "health_check" {
#   description = "task definition health check"
#   type        = any
#   default     = null
# }

# variable "port_name" {
#   description = "task definition health check"
#   type        = any
#   default     = null
# }

variable "container_definitions" {
  description = "Additional container definitions (sidecars) to use for the task."
  type        = any
  default     = []
}