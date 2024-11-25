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
      # dynamic "fsx_windows_file_server_volume_configuration" {
      #   for_each = volume.value.fsx_windows_file_server_volume_configuration != null ? [volume.value.fsx_windows_file_server_volume_configuration] : []

      #   content {
      #           file_system_id      = fsx_windows_file_server_volume_configuration.value.file_system_id
      #           root_directory      = fsx_windows_file_server_volume_configuration.value.root_directory
      #     dynamic "authorization_config" {
      #       for_each = fsx_windows_file_server_volume_configuration.value.authorization_config != null ? [
      #         fsx_windows_file_server_volume_configuration.value.authorization_config
      #       ] : []
      #       content {
      #         credentials_parameter = authorization_config.value.credentials_parameter
      #         domain = authorization_config.value.domain
      #       }
      #     }
      #   }
      # }
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
}