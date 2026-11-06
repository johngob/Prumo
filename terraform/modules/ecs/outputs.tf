output "cluster_name" {
  description = "Nome do Cluster ECS"
  value       = aws_ecs_cluster.main.name
}

output "service_name" {
  description = "Nome do Servico ECS"
  value       = aws_ecs_service.main.name
}

output "security_group_id" {
  description = "ID do Security Group da Task"
  value       = aws_security_group.ecs_task_sg.id
}

