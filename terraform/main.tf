terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source             = "./modules/network"
  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

module "ecs" {
  source                    = "./modules/ecs"
  project_name              = var.project_name
  aws_region                = var.aws_region
  vpc_id                    = module.network.vpc_id
  public_subnet_id          = module.network.public_subnet_id
  task_cpu                  = var.task_cpu
  task_memory               = var.task_memory
  web_image                 = var.web_image
  web_port                  = var.web_port
  api_image                 = var.api_image
  api_port                  = var.api_port
  api_environment_variables = var.api_environment_variables
  db_image                  = var.db_image
  db_port                   = var.db_port
  db_environment_variables  = var.db_environment_variables
}
