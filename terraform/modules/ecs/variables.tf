variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "aws_region" {
  description = "Regiao AWS"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "ID da subnet publica onde a task sera executada"
  type        = string
}

variable "task_cpu" {
  description = "Quantidade de CPU para a task compartilhada entre os 3 containers (ex: 512 = 0.5 vCPU)"
  type        = string
  default     = "512"
}

variable "task_memory" {
  description = "Quantidade de memoria em MB para a task compartilhada entre os 3 containers (ex: 1024 = 1GB)"
  type        = string
  default     = "1024"
}

# Frontend Web
variable "web_image" {
  description = "Imagem Docker do frontend Web (Angular + Nginx)"
  type        = string
}

variable "web_port" {
  description = "Porta publica exposta pelo frontend Web"
  type        = number
  default     = 80
}

# Backend API
variable "api_image" {
  description = "Imagem Docker do backend API (NestJS)"
  type        = string
}

variable "api_port" {
  description = "Porta interna da API NestJS"
  type        = number
  default     = 3000
}

variable "api_environment_variables" {
  description = "Lista de variaveis de ambiente para a API (name e value)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# Banco de Dados
variable "db_image" {
  description = "Imagem Docker do banco de dados (PostgreSQL)"
  type        = string
  default     = "postgres:16-alpine"
}

variable "db_port" {
  description = "Porta interna do banco de dados"
  type        = number
  default     = 5432
}

variable "db_environment_variables" {
  description = "Lista de variaveis de ambiente para o banco de dados (name e value)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
