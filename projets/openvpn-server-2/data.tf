# Recherche de l'image Ubuntu la plus récente
data "aws_ami" "ubuntu" {
  # Prendre l'AMI la plus récente correspondant au filtre
  most_recent = true

  # Filtre sur le nom de l'AMI
  filter {
    # Filtrage sur l'attribut name
    name = "name"

    # Ubuntu 24.04 Noble amd64 sur gp3
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  # Limiter la recherche aux AMI officielles Canonical
  owners = ["099720109477"]
}

# Récupération du VPC par défaut
data "aws_vpc" "default" {
  # Demande le VPC par défaut
  # vpc-0a6e5074c2755a2b7
  default = true
}

# 