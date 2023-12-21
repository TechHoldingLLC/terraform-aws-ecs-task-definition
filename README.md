## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_task_definition.task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ecs_task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_kms_alias.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_retention_in_days"></a> [cloudwatch\_log\_retention\_in\_days](#input\_cloudwatch\_log\_retention\_in\_days) | Retention period for cloudwatch log group | `number` | n/a | yes |
| <a name="input_command"></a> [command](#input\_command) | Task command | `string` | `null` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | ECS secrets environment variables | `map(string)` | n/a | yes |
| <a name="input_image"></a> [image](#input\_image) | ECR image | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | ECS task definition name | `string` | n/a | yes |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host. | `string` | `"awsvpc"` | no |
| <a name="input_port"></a> [port](#input\_port) | ECS container port | `number` | `0` | no |
| <a name="input_requires_compatibilities"></a> [requires\_compatibilities](#input\_requires\_compatibilities) | A set of launch types required by the task. The valid values are EC2 and FARGATE. | `list(string)` | n/a | yes |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | ECS task definition health check | `any` | n/a | no |
| <a name="input_secret_environment_variables"></a> [secret\_environment\_variables](#input\_secret\_environment\_variables) | ECS secrets environment variables | `map(string)` | n/a | yes |
| <a name="input_ssm_kms_alias"></a> [ssm\_kms\_alias](#input\_ssm\_kms\_alias) | SSM kms key alias | `string` | `"alias/aws/ssm"` | no |
| <a name="input_task_cpu"></a> [task\_cpu](#input\_task\_cpu) | ECS fargate task cpu | `number` | n/a | yes |
| <a name="input_task_memory"></a> [task\_memory](#input\_task\_memory) | ECS fargate task memory | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_environment_variables"></a> [environment\_variables](#output\_environment\_variables) | n/a |
| <a name="output_execution_role_arn"></a> [execution\_role\_arn](#output\_execution\_role\_arn) | n/a |
| <a name="output_execution_role_name"></a> [execution\_role\_name](#output\_execution\_role\_name) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | n/a |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | n/a |
| <a name="output_secret_environment_variables"></a> [secret\_environment\_variables](#output\_secret\_environment\_variables) | n/a |

## License

Apache 2 Licensed. See [LICENSE](https://github.com/TechHoldingLLC/terraform-aws-ecs-task-definition/blob/main/LICENSE) for full details.