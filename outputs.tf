output "service_name" {
  value = aws_ecs_service.jnv_ecs_service.name
}
output "secret_arn" {
  value = aws_secretsmanager_secret.jnv_ecs_service_secrets.arn
}

output "ecs_service_sg_id" {
  value = aws_security_group.jnv_ecs_service_sg.id
}
