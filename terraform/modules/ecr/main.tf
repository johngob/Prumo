resource "aws_ecr_repository" "web" {
  name                 = "${var.project_name}-web"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-web-ecr"
  }
}

resource "aws_ecr_lifecycle_policy" "web_policy" {
  repository = aws_ecr_repository.web.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Manter apenas as ultimas 2 imagens para reducao de custos"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_ecr_repository" "api" {
  name                 = "${var.project_name}-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-api-ecr"
  }
}

resource "aws_ecr_lifecycle_policy" "api_policy" {
  repository = aws_ecr_repository.api.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Manter apenas as ultimas 2 imagens para reducao de custos"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

output "web_repository_url" {
  description = "URL do repositorio ECR do frontend web"
  value       = aws_ecr_repository.web.repository_url
}

output "web_repository_name" {
  description = "Nome do repositorio ECR do frontend web"
  value       = aws_ecr_repository.web.name
}

output "api_repository_url" {
  description = "URL do repositorio ECR do backend api"
  value       = aws_ecr_repository.api.repository_url
}

output "api_repository_name" {
  description = "Nome do repositorio ECR do backend api"
  value       = aws_ecr_repository.api.name
}
