variable "application_name" {}
variable "jnv_project" {
  default = "szs"
}
variable "jnv_region" {
  default = "apne2"
}
variable "jnv_environment" {
  default = "dev"
}
variable "vpc_id" {
  default = "vpc-0cd28aa2e0e8c8cf7"
}
variable "subnet_ids" {
  default = ["subnet-041191089c7344807", "subnet-0b188546bc60a1e37"]
}
variable "cluster_arn" {
  default = "arn:aws:ecs:ap-northeast-2:185236431346:cluster/szs-apne2-ecs-dev"
}
variable "need_loadbalancer" {
  type    = bool
  default = false
}
variable "loadbalaner_arn" {
  default = "arn:aws:elasticloadbalancing:ap-northeast-2:185236431346:loadbalancer/app/szs-apne2-prv-alb-dev/4ed916fe776dedba"
}
variable "container_port" {
  default = 8080
}
variable "listener_port" {
  default = 8888
}
variable "listener_protocol" {
  default = "HTTP"
}
variable "listener_ssl_policy" {
  default = null
}
variable "loadbalancer_sg" {
  default = "sg-065f2646decd01027"
}
variable "tg_health_check" {
  type = object({
    enabled             = bool
    healthy_threshold   = number
    interval            = number
    matcher             = string
    path                = string
    port                = string
    protocol            = string
    timeout             = number
    unhealthy_threshold = number
  })

  default = {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/actuator/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

variable "listener_rule_priority" {
  default = 99999
}

variable "management_sg" {
  type    = string
  default = "sg-0d53edaaf7f0713bb"
}
