# JNV_ECS_PROJECT_DEV

## description
* DEV 환경 ECS 서비스를 구성하는 모듈

## example
```
module "jnv_ecs_project_dev" {
  source            = "git::https://github.com/JeonghwanSa/jnv-ecs-project-dev.git"
  application_name  = "jobis-example"
  need_loadbalancer = false
}
```