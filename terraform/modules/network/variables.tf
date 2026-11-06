variable "project_name" {
  description = "Nome do projeto para identificar os recursos"
  type        = string
  default     = "projeto-aula"
}

variable "vpc_cidr" {
  description = "Bloco CIDR para a VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Bloco CIDR para a subnet publica"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Zona de disponibilidade para a subnet"
  type        = string
  default     = "us-east-1a"
}

