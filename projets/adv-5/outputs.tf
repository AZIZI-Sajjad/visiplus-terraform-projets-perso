output "public_ip" {
  description = "Adresse IP publique de l'instance"
  value       = oci_core_instance.vps.public_ip
}

output "private_ip" {
  description = "Adresse IP privée de l'instance"
  value       = oci_core_instance.vps.private_ip
}

output "instance_id" {
  description = "OCID de l'instance créée"
  value       = oci_core_instance.vps.id
}

output "ssh_command" {
  description = "Commande SSH prête à l'emploi"
  value       = "ssh ubuntu@${oci_core_instance.vps.public_ip}"
}
