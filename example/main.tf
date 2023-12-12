module "ecs_task_definition" {
  source                           = "../"
  name                             = "demo-ecs-task-definition"
  image                            = "nginx/nginx"
  task_cpu                         = 256
  task_memory                      = 512
  command                          = ""
  port                             = 80
  cloudwatch_log_retention_in_days = var.env == "prod" ? 90 : 30
  health_check = {
    command     = ["CMD-SHELL", "curl -f http://localhost:${var.container_port}${var.task_health_check_path} || exit 1"]
    interval    = 30
    timeout     = 5
    retries     = 2
    startPeriod = 0 # should be passed from variable
  }
  requires_compatibilities         = ["FARGATE"]
  network_mode                     = "awsvpc"
  environment_variables = {
  }
  secret_environment_variables = {
  }
}