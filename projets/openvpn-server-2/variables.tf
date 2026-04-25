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


# Variable pour l'IP à autoriser
variable "aws_region" {
  # Type de la variable
  type = string
}

# Variable pour l'IP à autoriser
variable "ec2_hostname" {
  # Type de la variable
  type = string
}

# Variable pour l'IP à autoriser
variable "app_name" {
  # Type de la variable
  type = string
}


## Définition des utilisateurs OpenVPN via une liste de maps (list of objects)
variable "openvpn_clients" {
  type = list(object({
  openvpn_username = string
  openvpn_password = string
  }))
    sensitive = true
}

# Variable pour définir le port d'openvpn
variable "openvpn_port" {
  # Type de la variable
  type = number
}

# 