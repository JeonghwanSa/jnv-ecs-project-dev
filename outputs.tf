output "service_name" {
  value = aws_ecs_service.jnv_ecs_service.name
}
output "secret_arn" {
  value = "arn:aws:secretsmanager:ap-northeast-2:185236431346:secret:no-use"
}

output "ecs_service_sg_id" {
  value = aws_security_group.jnv_ecs_service_sg.id
}
