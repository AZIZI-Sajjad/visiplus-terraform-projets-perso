# Bloc principal Terraform
terraform {
  # Providers nécessaires au projet
  required_providers {
    # Provider AWS officiel HashiCorp
    aws = {
      # Source du provider AWS
      source = "hashicorp/aws"

      # Version du provider AWS
      # version = "~> 5.92"
      version = "~> 6.40"
    }
  }

  # Version minimale de Terraform requise
  required_version = ">= 1.2"
}
# 