
# Afficher l'IP publique de l'instance créée
output "instance_public_ip" {
  # Description de la valeur affichée
  description = "Adresse IP publique de l'instance"

  # IP publique de l'instance EC2
  value = aws_instance.app_server_live.public_ip
}


# 