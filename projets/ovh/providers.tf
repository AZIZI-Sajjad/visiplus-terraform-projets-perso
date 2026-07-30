# Configuration du provider OVH
terraform {
  required_providers {
    ovh = {
      source = "ovh/ovh"
    }
  }
}

# Variable pour endpoint OVH
variable "endpoint" {
  # Type de la variable
  type = string
}

# Variable pour client_id
variable "client_id" {
  # Type de la variable
  type = string
}

# Variable pour client_secret
variable "client_secret" {
  # Type de la variable
  type = string
}

#
  # provider "ovh/ovh" {
  provider "ovh" {
  # Région OVH utilisée
  endpoint = var.endpoint
 
  # Clé d'accès OVH
  client_id = var.client_id

  # Clé secrète OVH
  client_secret = var.client_secret
}

