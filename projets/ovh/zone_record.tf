# Variable pour zone
variable "zone" {
  # Type de la variable
  type = string
}

# Variable pour subdomain
variable "subdomain" {
  # Type de la variable
  type = string
}


# Variable pour target
variable "target" {
  # Type de la variable
  type = string
}


resource "ovh_domain_zone_record" "domain_zone_record" {
  zone      = var.zone
  subdomain = var.subdomain
  target    = var.target
  fieldtype = "A"
  ttl       = 60
}
