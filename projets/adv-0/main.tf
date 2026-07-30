# Bloc principal Terraform
terraform {
  # Providers nécessaires au projet
  required_providers {
    # Provider AWS officiel HashiCorp
    aws = {
      # Source du provider AWS
      source = "hashicorp/aws"

      # Version du provider AWS
      version = "~> 5.92"
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
  default = true
}

# Création du security group du serveur applicatif
resource "aws_security_group" "app_server_live_sg" {
  # Nom du security group
  name = "app_server_live_sg"

  # Description du security group
  description = "allow inbound traffic on ports 80, 9229, 9230, 3000, 3306 and allow all outbound"

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
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autoriser le port 3000 depuis n'importe quelle IP
  ingress {
    # Description de la règle
    description = "Allow front port (3000)"

    # Port source
    from_port = 3000

    # Port destination
    to_port = 3000

    # Protocole utilisé
    protocol = "tcp"

    # Autoriser depuis toutes les IP
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autoriser le port 80 depuis n'importe quelle IP
  ingress {
    # Description de la règle
    description = "Allow backend port (80)"

    # Port source
    from_port = 80

    # Port destination
    to_port = 80

    # Protocole utilisé
    protocol = "tcp"

    # Autoriser depuis toutes les IP
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autoriser le port 9229 depuis n'importe quelle IP
  ingress {
    # Description de la règle
    description = "Allow backend port (9229)"

    # Port source
    from_port = 9229

    # Port destination
    to_port = 9229

    # Protocole utilisé
    protocol = "tcp"

    # Autoriser depuis toutes les IP
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autoriser le port 9230 depuis n'importe quelle IP
  ingress {
    # Description de la règle
    description = "Allow backend port (9230)"

    # Port source
    from_port = 9230

    # Port destination
    to_port = 9230

    # Protocole utilisé
    protocol = "tcp"

    # Autoriser depuis toutes les IP
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autoriser le port MariaDB 3306 depuis n'importe quelle IP
  ingress {
    # Description de la règle
    description = "Allow mariadb database port (3306)"

    # Port source
    from_port = 3306

    # Port destination
    to_port = 3306

    # Protocole utilisé
    protocol = "tcp"

    # Autoriser depuis toutes les IP
    cidr_blocks = ["0.0.0.0/0"]
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

  # Tags du security group
  tags = {
    # Nom affiché dans AWS
    Name = "app_server_live_sg"
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
 # Copie du script local vers le VPS
  provisioner "file" {
    # Script présent sur la machine locale
    source = "script.sh"

    # Chemin de destination sur le VPS
    destination = "/tmp/script.sh"
  }

  # Exécution du script copié sur le VPS
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh"
    ]
  }

  # Tags de l'instance
  tags = {
    # Nom affiché dans AWS pour l'instance
    Name = "learn-terraform"
  }
}