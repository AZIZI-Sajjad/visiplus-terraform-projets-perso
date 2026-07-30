# terraform {
#   required_providers {
#     ovh = {
#       source = "ovh/ovh"
#     }
#   }
# }

# # Variable pour endpoint OVH
# variable "endpoint" {
#   # Type de la variable
#   type = string
# }

# # Variable pour client_id
# variable "client_id" {
#   # Type de la variable
#   type = string
# }

# # Variable pour client_secret
# variable "client_secret" {
#   # Type de la variable
#   type = string
# }

# # Variable pour zone
# variable "zone" {
#   # Type de la variable
#   type = string
# }

# # Variable pour subsomain
# variable "subsomain" {
#   # Type de la variable
#   type = string
# }


# # Variable pour target
# variable "target" {
#   # Type de la variable
#   type = string
# }


# provider "ovh" {
#   endpoint = var.endpoint
# }

# resource "ovh_domain_zone_record" "domain_zone_record" {
#   zone      = var.zone
#   subdomain = var.subdomain
#   target    = var.target
#   fieldtype = var.fieldtype
#   fieldtype = "A"
#   ttl       = 60
# }




