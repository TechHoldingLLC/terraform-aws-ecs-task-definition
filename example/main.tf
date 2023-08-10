module "ecs_task_definition" {
  source                           = "../"
  name                             = "demo-ecs-task-definition"
  image                            = "nginx/nginx"
  task_cpu                         = 256
  task_memory                      = 512
  command                          = ""
  port                             = 80
  cloudwatch_log_retention_in_days = var.env == "prod" ? 90 : 30
  requires_compatibilities         = ["FARGATE"]
  network_mode                     = "awsvpc"
  environment_variables = {
  }
  secret_environment_variables = {
  }
}