################################################
#  ecs-task-defination/ecs-task-defination.tf  #
################################################

resource "aws_ecs_task_definition" "task" {
  family                   = var.name
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.task.arn
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions    = jsonencode(var.container_definitions)

  # Ephemeral storage
  dynamic "ephemeral_storage" {
    for_each = coalesce(var.ephemeral_storage_size, 0) > 0 ? { "ephemeral" = var.ephemeral_storage_size } : {}
    content {
      size_in_gib = ephemeral_storage.value
    }
  }

  # Volumes Configuration
  dynamic "volume" {
    for_each = var.volumes

    content {
      name      = volume.value.name
      host_path = try(volume.value.host_path, null)

      dynamic "docker_volume_configuration" {
        for_each = volume.value.docker_volume_configuration != null ? [volume.value.docker_volume_configuration] : []

        content {
          autoprovision = docker_volume_configuration.value.autoprovision
          driver        = docker_volume_configuration.value.driver
          driver_opts   = docker_volume_configuration.value.driver_opts
          labels        = docker_volume_configuration.value.labels
          scope         = docker_volume_configuration.value.scope
        }
      }
      dynamic "efs_volume_configuration" {
        for_each = volume.value.efs_volume_configuration != null ? [volume.value.efs_volume_configuration] : []

        content {
          file_system_id          = efs_volume_configuration.value.file_system_id
          root_directory          = efs_volume_configuration.value.root_directory
          transit_encryption      = efs_volume_configuration.value.transit_encryption
          transit_encryption_port = efs_volume_configuration.value.transit_encryption_port

          dynamic "authorization_config" {
            for_each = efs_volume_configuration.value.authorization_config != null ? [
              efs_volume_configuration.value.authorization_config
            ] : []

            content {
              access_point_id = authorization_config.value.access_point_id
              iam             = authorization_config.value.iam
            }
          }
        }
      }
    }
  }

  dynamic "runtime_platform" {
    for_each = var.runtime_platform != null ? [var.runtime_platform] : []

    content {
      operating_system_family = runtime_platform.value.operating_system_family
      cpu_architecture        = runtime_platform.value.cpu_architecture
    }
  }
}
