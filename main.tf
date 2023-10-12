data "aws_caller_identity" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_secretsmanager_secret" "jnv_ecs_service_secrets" {
  name = join("-", ["${var.jnv_project}", "${var.jnv_region}", lower("${var.application_name}"), "seckey", "${var.jnv_environment}"])
}

resource "aws_lb_listener" "jnv_ecs_service_alb_listener" {
  count = var.need_loadbalancer ? 1 : 0

  alpn_policy       = null
  certificate_arn   = null
  load_balancer_arn = var.loadbalaner_arn
  port              = var.listener_port
  protocol          = "HTTP"
  ssl_policy        = null
  tags              = {}
  tags_all          = {}
  default_action {
    target_group_arn = aws_lb_target_group.jnv_ecs_service_alb_tg[0].arn
    type             = "forward"
  }
}

# resource "aws_lb_listener_rule" "jnv_ecs_service_alb_rule" {
#   count = var.need_loadbalancer ? 1 : 0

#   listener_arn = aws_lb_listener.jnv_ecs_service_alb_listener[0].arn
#   priority     = var.listener_rule_priority
#   tags         = {}
#   tags_all     = {}
#   action {
#     target_group_arn = aws_lb_target_group.jnv_ecs_service_alb_tg[0].arn
#     type             = "forward"
#   }
#   condition {
#     path_pattern {
#       values = ["/*"]
#     }
#   }
# }

resource "aws_lb_target_group" "jnv_ecs_service_alb_tg" {
  count = var.need_loadbalancer ? 1 : 0

  connection_termination             = null
  deregistration_delay               = "300"
  ip_address_type                    = "ipv4"
  lambda_multi_value_headers_enabled = null
  load_balancing_algorithm_type      = "round_robin"
  load_balancing_cross_zone_enabled  = "use_load_balancer_configuration"
  name                               = join("-", ["${var.jnv_project}", "${var.jnv_region}", lower("${var.application_name}"), "tg", "${var.jnv_environment}"])
  name_prefix                        = null
  port                               = 80
  preserve_client_ip                 = null
  protocol                           = "HTTP"
  protocol_version                   = "HTTP1"
  proxy_protocol_v2                  = null
  slow_start                         = 0
  tags                               = {}
  tags_all                           = {}
  target_type                        = "ip"
  vpc_id                             = var.vpc_id
  health_check {
    enabled             = var.tg_health_check.enabled
    healthy_threshold   = var.tg_health_check.healthy_threshold
    interval            = var.tg_health_check.interval
    matcher             = var.tg_health_check.matcher
    path                = var.tg_health_check.path
    port                = var.tg_health_check.port
    protocol            = var.tg_health_check.protocol
    timeout             = var.tg_health_check.timeout
    unhealthy_threshold = var.tg_health_check.unhealthy_threshold
  }
  stickiness {
    cookie_duration = 86400
    cookie_name     = null
    enabled         = false
    type            = "lb_cookie"
  }
}

resource "aws_ecr_repository" "jnv_ecs_service_ecr_repo" {
  force_delete         = null
  image_tag_mutability = "MUTABLE"
  name                 = join("-", ["${var.jnv_project}", "${var.jnv_region}", lower("${var.application_name}"), "ecr", "${var.jnv_environment}"])
  tags                 = {}
  tags_all             = {}
  encryption_configuration {
    encryption_type = "AES256"
    kms_key         = null
  }
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_task_definition" "jnv_ecs_service_taskdef" {
  family = join("-", ["${var.jnv_project}", "${var.jnv_region}", lower("${var.application_name}"), "ecs-task", "${var.jnv_environment}"])
  container_definitions = jsonencode([
    {
      command     = []
      cpu         = 0
      entryPoint  = []
      environment = []
      essential   = true
      image       = join(":", ["${aws_ecr_repository.jnv_ecs_service_ecr_repo.repository_url}", "init"])
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = join("-", ["/ecs/${var.jnv_project}", "${var.jnv_region}", lower("${var.application_name}"), "ecs-task", "${var.jnv_environment}"])
          awslogs-region        = "ap-northeast-2"
          awslogs-stream-prefix = "ecs"
        }
      }
      mountPoints = []
      name        = join("-", ["${var.jnv_project}", "${var.jnv_region}", lower("${var.application_name}"), "container", "${var.jnv_environment}"])
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      secrets = [
        {
          name      = "ENC_KEY"
          valueFrom = aws_secretsmanager_secret.jnv_ecs_service_secrets.arn
        }
      ]
      volumesFrom = []
    }
  ])
  cpu                      = "1024"
  execution_role_arn       = "arn:aws:iam::${local.account_id}:role/ecsTaskExecutionRole"
  ipc_mode                 = null
  memory                   = "3072"
  network_mode             = "awsvpc"
  pid_mode                 = null
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = null
  tags = {
    Application = var.application_name
    Environment = var.jnv_environment
    Owner       = "jnv"
    Project     = var.application_name
    Service     = "szs"
    Team        = var.application_name
    User        = "szs"
  }
  task_role_arn = "arn:aws:iam::${local.account_id}:role/ecsTaskExecutionRole"
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}

resource "aws_security_group" "jnv_ecs_service_sg" {
  name        = join("-", ["${var.jnv_project}", "${var.jnv_region}", lower("${var.application_name}"), "ecs-sg", "${var.jnv_environment}"])
  description = join("-", ["${var.jnv_project}", "${var.jnv_region}", lower("${var.application_name}"), "ecs-sg", "${var.jnv_environment}"])
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.need_loadbalancer == true ? [1] : []
    content {
      description = "from dev alb"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      security_groups = [
        var.loadbalancer_sg
      ]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = join("-", ["${var.jnv_project}", "${var.jnv_region}", lower("${var.application_name}"), "ecs-sg", "${var.jnv_environment}"])
  }
}

resource "aws_ecs_service" "jnv_ecs_service" {
  cluster                            = var.cluster_arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 0
  enable_ecs_managed_tags            = false
  enable_execute_command             = false
  force_new_deployment               = null
  health_check_grace_period_seconds  = 0
  # iam_role                           = "/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  launch_type           = "FARGATE"
  name                  = join("-", ["${var.jnv_project}", "${var.jnv_region}", lower("${var.application_name}"), "ecs-svc", "${var.jnv_environment}"])
  platform_version      = "LATEST"
  propagate_tags        = "NONE"
  scheduling_strategy   = "REPLICA"
  tags                  = {}
  tags_all              = {}
  task_definition       = aws_ecs_task_definition.jnv_ecs_service_taskdef.arn_without_revision
  triggers              = {}
  wait_for_steady_state = null
  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }
  deployment_controller {
    type = "ECS"
  }
  dynamic "load_balancer" {
    for_each = var.need_loadbalancer == true ? [1] : []
    content {
      container_name   = join("-", ["${var.jnv_project}", "${var.jnv_region}", lower("${var.application_name}"), "container", "${var.jnv_environment}"])
      container_port   = var.container_port
      elb_name         = null
      target_group_arn = aws_lb_target_group.jnv_ecs_service_alb_tg[0].arn
    }
  }
  network_configuration {
    assign_public_ip = false
    security_groups = [
      var.management_sg,
      aws_security_group.jnv_ecs_service_sg.id
    ]
    subnets = var.subnet_ids
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count
    ]
  }
}
