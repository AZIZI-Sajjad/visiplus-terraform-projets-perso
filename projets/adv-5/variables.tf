variable "tenancy_ocid" {
  description = "OCID du tenancy Oracle Cloud"
  type        = string
}

variable "user_ocid" {
  description = "OCID de l'utilisateur"
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint de la clé API"
  type        = string
}

variable "private_key_path" {
  description = "Chemin vers la clé privée API OCI"
  type        = string
}

variable "region" {
  description = "Région OCI"
  type        = string
  default     = "eu-paris-1"
}

variable "compartment_ocid" {
  description = "OCID du compartment cible"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Chemin vers la clé publique SSH pour l'instance"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "instance_name" {
  description = "Nom de l'instance VPS"
  type        = string
  default     = "srv-free-vps"
}

variable "availability_domain" {
  description = "Nom du AD - laisser vide pour prendre le premier disponible"
  type        = string
  default     = ""
}
