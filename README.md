# JNV_ECS_PROJECT_DEV

## Description
* DEV 환경 ECS 서비스를 구성하는 모듈

## Example
```
module "jnv_ecs_project_dev" {
  source            = "git::https://github.com/JeonghwanSa/jnv-ecs-project-dev.git"
  application_name  = "jobis-example"
  need_loadbalancer = false
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.jnv_ecs_service_ecr_repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_service.jnv_ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.jnv_ecs_service_taskdef](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_lb_listener.jnv_ecs_service_alb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.jnv_ecs_service_alb_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.jnv_ecs_service_alb_tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_secretsmanager_secret.jnv_ecs_service_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_security_group.jnv_ecs_service_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | n/a | `any` | n/a | yes |
| <a name="input_cluster_arn"></a> [cluster\_arn](#input\_cluster\_arn) | n/a | `string` | `"arn:aws:ecs:ap-northeast-2:185236431346:cluster/szs-apne2-ecs-dev"` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | n/a | `number` | `8080` | no |
| <a name="input_jnv_environment"></a> [jnv\_environment](#input\_jnv\_environment) | n/a | `string` | `"dev"` | no |
| <a name="input_jnv_project"></a> [jnv\_project](#input\_jnv\_project) | n/a | `string` | `"szs"` | no |
| <a name="input_jnv_region"></a> [jnv\_region](#input\_jnv\_region) | n/a | `string` | `"apne2"` | no |
| <a name="input_listener_port"></a> [listener\_port](#input\_listener\_port) | n/a | `number` | `8888` | no |
| <a name="input_listener_rule_priority"></a> [listener\_rule\_priority](#input\_listener\_rule\_priority) | n/a | `number` | `99999` | no |
| <a name="input_loadbalaner_arn"></a> [loadbalaner\_arn](#input\_loadbalaner\_arn) | n/a | `string` | `"arn:aws:elasticloadbalancing:ap-northeast-2:185236431346:loadbalancer/app/szs-apne2-prv-alb-dev/4ed916fe776dedba"` | no |
| <a name="input_management_sg"></a> [management\_sg](#input\_management\_sg) | n/a | `string` | `"sg-0d53edaaf7f0713bb"` | no |
| <a name="input_need_loadbalancer"></a> [need\_loadbalancer](#input\_need\_loadbalancer) | n/a | `bool` | `false` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | n/a | `list` | <pre>[<br>  "subnet-041191089c7344807",<br>  "subnet-0b188546bc60a1e37"<br>]</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | `"vpc-0cd28aa2e0e8c8cf7"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | n/a |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | n/a |