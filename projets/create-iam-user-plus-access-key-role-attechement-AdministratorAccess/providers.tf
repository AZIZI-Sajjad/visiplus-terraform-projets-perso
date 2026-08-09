# Provider AWS officiel HashiCorp
# provider aws = {}

# Configuration du provider AWS
provider "aws" {
  # Région AWS utilisée
  region = var.aws_region

  # Clé d'accès AWS
  access_key = var.access_key

  # Clé secrète AWS
  secret_key = var.secret_key
}

