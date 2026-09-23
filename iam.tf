########################
#  ecs-service/iam.tf  #
########################

### ECS task execution role
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.name}-ecs-task-execution"
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ecs-tasks.amazonaws.com"
          }
        }
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.id
  policy_arn = "arn:${local.aws_partition}:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_task_execution" {
  count = length(local.secret_sources) > 0 ? 1 : 0
  name  = aws_iam_role.ecs_task_execution.name
  role  = aws_iam_role.ecs_task_execution.name
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = concat(
        length(local.ssm_parameter_arns) > 0 ? [
          {
            Sid      = "ReadSSMParameters"
            Action   = "ssm:GetParameters"
            Effect   = "Allow"
            Resource = local.ssm_parameter_arns
          }
        ] : [],
        length(local.secretsmanager_secret_arns) > 0 ? [
          {
            Sid      = "ReadSecretsManagerSecrets"
            Action   = "secretsmanager:GetSecretValue"
            Effect   = "Allow"
            Resource = local.secretsmanager_secret_arns
          }
        ] : [],
        length(local.kms_key_arns) > 0 ? [
          {
            Sid      = "DecryptSecrets"
            Action   = "kms:Decrypt"
            Effect   = "Allow"
            Resource = local.kms_key_arns
          }
        ] : []
      )
    }
  )
}

## ECS task role
resource "aws_iam_role" "task" {
  name = "${var.name}-ecs-task"
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ecs-tasks.amazonaws.com"
          }
        }
      ]
      Version = "2012-10-17"
    }
  )
}
