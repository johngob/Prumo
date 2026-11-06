variable "aws_region" {
  description = "Regiao da AWS onde os recursos serao criados"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefixo de nome dos recursos do projeto"
  type        = string
  default     = "prumo-app"
}

# Rede
variable "vpc_cidr" {
  description = "Bloco CIDR da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Bloco CIDR da Subnet Publica"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Zona de disponibilidade da AWS para a subnet"
  type        = string
  default     = "us-east-1a"
}

# ECS Fargate (compartilhado entre os 3 containers)
variable "task_cpu" {
  description = "vCPU da task (ex: 512 = 0.5 vCPU, 1024 = 1.0 vCPU)"
  type        = string
  default     = "512"
}

variable "task_memory" {
  description = "Memoria RAM da task em MB (ex: 1024 = 1GB, 2048 = 2GB)"
  type        = string
  default     = "1024"
}

# Frontend Web
variable "web_image" {
  description = "Imagem Docker do frontend Web (Angular + Nginx)"
  type        = string
  default     = "nginx:alpine"
}

variable "web_port" {
  description = "Porta publica na qual o frontend Web escuta"
  type        = number
  default     = 80
}

# Backend API
variable "api_image" {
  description = "Imagem Docker do backend API (NestJS)"
  type        = string
  default     = "node:20-alpine"
}

variable "api_port" {
  description = "Porta na qual a API NestJS escuta"
  type        = number
  default     = 3000
}

variable "api_environment_variables" {
  description = "Variaveis de ambiente para a API"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "NODE_ENV"
      value = "production"
    },
    {
      name  = "PORT"
      value = "3000"
    },
    {
      name  = "DB_HOST"
      value = "localhost" # No awsvpc compartilhado, usa localhost
    },
    {
      name  = "DB_PORT"
      value = "5432"
    }
  ]
}

# Banco de Dados
variable "db_image" {
  description = "Imagem Docker do banco de dados"
  type        = string
  default     = "postgres:16-alpine"
}

variable "db_port" {
  description = "Porta interna do banco de dados"
  type        = number
  default     = 5432
}

variable "db_environment_variables" {
  description = "Variaveis de ambiente para o container do banco de dados"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "POSTGRES_DB"
      value = "prumodb"
    },
    {
      name  = "POSTGRES_USER"
      value = "prumouser"
    },
    {
      name  = "POSTGRES_PASSWORD"
      value = "PrumoPostgresSeguro123!"
    }
  ]
}
