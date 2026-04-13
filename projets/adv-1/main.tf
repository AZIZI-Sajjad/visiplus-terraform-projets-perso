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

# Variable pour l'IP à autoriser
variable "saz_ip" {
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

# Création du security group du serveur applicatif
resource "aws_security_group" "app_server_live_sg" {
  # Nom du security group
  name = "app_server_live_sg"

  # Description du security group
  description = "allow inbound traffic on port HTTP 80 and allow all outbound"

  # Association au VPC par défaut
  vpc_id = data.aws_vpc.default.id

  # Autoriser SSH depuis n'importe quelle IP
  ingress {
    # Description de la règle
    description = "Allow ssh (port 22) from all ip adress"

    # Port source
    from_port = 22

    # Port destination
    to_port = 22

    # Protocole utilisé
    protocol = "tcp"

    # Autoriser depuis toutes les IP
    cidr_blocks = [var.saz_ip]
  }

  # Autoriser HTTP depuis n'importe quelle IP
  ingress {
    # Description de la règle
    description = "Allow HTTP (port 80) from saz_ip ip adress"

    # Port source
    from_port = 80

    # Port destination
    to_port = 80

    # Protocole utilisé
    protocol = "tcp"

    # Autoriser depuis toutes les IP
    cidr_blocks = [var.saz_ip]
  }


    # Autoriser tout le trafic sortant
  egress {
    # Description de la règle
    description = "Allow all outbound traffic"

    # Tous les ports
    from_port = 0

    # Tous les ports
    to_port = 0

    # Tous les protocoles
    protocol = "-1"

    # Autoriser vers toutes les IP
    cidr_blocks = ["0.0.0.0/0"]
  }

}


# Création de l'instance EC2
resource "aws_instance" "app_server_live" {
  # ID de l'AMI Ubuntu récupérée plus haut
  ami = data.aws_ami.ubuntu.id

  # Type d'instance EC2
  instance_type = "t3.micro"

  # Nom de la clé SSH AWS à utiliser
  key_name = "aws-ci-cd-deploy"

  # Association du security group à l'instance
  vpc_security_group_ids = [aws_security_group.app_server_live_sg.id]

  # Script d'installation de Docker & Docker compose, qui sera injecté par terraform, et exécuté dans le VPS après la création 
  user_data = <<-EOF
        #!/bin/bash
        sudo apt update
        sudo apt install -y docker.io git curl

        # install docker compose
        sudo mkdir -p /usr/local/lib/docker/cli-plugins
        sudo curl -SL https://github.com/docker/compose/releases/download/v2.39.3/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose

        # access to docker compose from current user
        sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
        sudo chown root:root /usr/local/lib/docker/cli-plugins/docker-compose
        sudo usermod -aG docker ubuntu

        # get project
        cd /home/ubuntu/
        git clone https://github.com/docker/awesome-compose.git
        cd awesome-compose/apache-php

        # Démarrer le compose
        sudo -u ubuntu docker compose -f ./compose.yaml up -d
      EOF

  # Tags de l'instance
  tags = {
    # Nom affiché dans AWS pour l'instance
    Name = "vps-ec2-apache-php"
  }
}

# Afficher l'IP publique de l'instance créée
output "instance_public_ip" {
  # Description de la valeur affichée
  description = "Adresse IP publique de l'instance"

  # IP publique de l'instance EC2
  value = aws_instance.app_server_live.public_ip
}