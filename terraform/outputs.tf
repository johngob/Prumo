output "vpc_id" {
  description = "ID da VPC criada"
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "ID da Subnet Publica"
  value       = module.network.public_subnet_id
}

output "ecs_cluster_name" {
  description = "Nome do Cluster ECS"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "Nome do Servico ECS"
  value       = module.ecs.service_name
}

output "ecr_web_repository_url" {
  description = "URL do Repositorio ECR do Frontend Web"
  value       = module.ecr.web_repository_url
}

output "ecr_api_repository_url" {
  description = "URL do Repositorio ECR do Backend API"
  value       = module.ecr.api_repository_url
}

output "how_to_get_public_ip" {
  description = "Comando AWS CLI para obter o IP publico da task em execucao"
  value       = "aws ecs list-tasks --cluster ${module.ecs.cluster_name} --service-name ${module.ecs.service_name} --query 'taskArns[0]' --output text | ForEach-Object { aws ecs describe-tasks --cluster ${module.ecs.cluster_name} --tasks $_ --query 'tasks[0].attachments[0].details[?name==`networkInterfaceId`].value' --output text } | ForEach-Object { aws ec2 describe-network-interfaces --network-interface-ids $_ --query 'NetworkInterfaces[0].Association.PublicIp' --output text }"
}
