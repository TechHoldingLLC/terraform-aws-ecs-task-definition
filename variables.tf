######################################
#  ecs-task-defination/variables.tf  #
######################################

variable "name" {
  description = "ECS task definition name"
  type        = string
}

variable "network_mode" {
  description = "Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host."
  type        = string
  default     = "awsvpc"
}

variable "requires_compatibilities" {
  description = " A set of launch types required by the task. The valid values are EC2 and FARGATE."
  type        = list(string)
  default     = ["FARGATE"]
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

variable "container_definitions" {
  description = "Additional container definitions (sidecars) to use for the task."
  type        = any
  default     = []
}