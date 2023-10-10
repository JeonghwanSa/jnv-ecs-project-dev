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

variable "listener_rule_priority" {
  default = 99999
}

variable "management_sg" {
  type    = string
  default = "sg-0d53edaaf7f0713bb"
}

variable "ecs_service_lb_sg" {
  type    = string
  default = "sg-065f2646decd01027"
}
