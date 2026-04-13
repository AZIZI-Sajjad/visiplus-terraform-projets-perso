# Bloc principal Terraform
terraform {
  # Providers nécessaires au projet
  required_providers {
    # Provider AWS officiel HashiCorp
    aws = {
      # Source du provider AWS
      source = "hashicorp/aws"

      # Version du provider AWS
      version = "~> 6.40"
      # version = "~> 5.92"
    }
  }

  # Version minimale de Terraform requise
  required_version = ">= 1.2"
}

# Variable pour la clé d'accès AWS
variable "access_key" {
  # Type de la variable
  type = string
}

# Variable pour la clé secrète AWS
variable "secret_key" {
  # Type de la variable
  type = string
}

# Configuration du provider AWS
provider "aws" {
  # Région AWS utilisée
  region = "eu-west-3"

  # Clé d'accès AWS
  access_key = var.access_key

  # Clé secrète AWS
  secret_key = var.secret_key
}
######################### Fin de basic 


data "aws_instances" "test" {
  instance_tags = {
    Role = "HardWorker"
  }

  # filter {
  #   name   = "instance.group-id"
  #   values = ["sg-12345678"]
  # }

  instance_state_names = ["running", "stopped"]
}

resource "aws_eip" "test" {
  count    = length(data.aws_instances.test.ids)
  instance = data.aws_instances.test.ids[count.index]
}

