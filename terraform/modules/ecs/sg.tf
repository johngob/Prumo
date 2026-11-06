resource "aws_security_group" "ecs_task_sg" {
  name        = "${var.project_name}-ecs-task-sg"
  description = "Security Group para a task ECS Fargate"
  vpc_id      = var.vpc_id

  # Entrada para o frontend Web vindo da Internet (Porta 80)
  ingress {
    description = "Acesso HTTP externo para o Frontend Web"
    from_port   = var.web_port
    to_port     = var.web_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Entrada opcional para a API diretamente (Porta 3000) caso queira testar Swagger externamente
  ingress {
    description = "Acesso HTTP direto para a API"
    from_port   = var.api_port
    to_port     = var.api_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Saida liberada para o ECS baixar imagens e mandar logs
  egress {
    description = "Permitir saida total (download de imagens e logs)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ecs-task-sg"
  }
}
