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

variable "volumes" {
  description = "A list of volume definitions."
  type = list(object({
    name      = string
    host_path = optional(string)

    docker_volume_configuration = optional(object({
      autoprovision = optional(bool)
      driver        = optional(string)
      driver_opts   = optional(map(any))
      labels        = optional(map(any))
      scope         = optional(string)
    }))

    efs_volume_configuration = optional(object({
      file_system_id          = string
      root_directory          = optional(string)
      transit_encryption      = optional(string)
      transit_encryption_port = optional(number)

      authorization_config = optional(object({
        access_point_id = string
        iam             = optional(string)
      }))
    }))
  }))
  default = []
}

variable "ephemeral_storage_size" {
  type    = number
  default = null
}