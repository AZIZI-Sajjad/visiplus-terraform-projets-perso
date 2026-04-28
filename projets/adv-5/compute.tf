# Récupération de la dernière image Ubuntu 22.04 compatible E2.1.Micro
data "oci_core_images" "ubuntu" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.E2.1.Micro"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "vps" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain != "" ? var.availability_domain : data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name        = var.instance_name
  shape               = "VM.Standard.E2.1.Micro"

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet.id
    assign_public_ip = true
    hostname_label   = "freevps"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu.images[0].id
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
    user_data = base64encode(<<-EOT
      #!/bin/bash
      apt-get update -y
      apt-get install -y fail2ban iptables-persistent
      iptables -I INPUT 5 -p tcp --dport 80 -m state --state NEW -j ACCEPT
      iptables -I INPUT 5 -p tcp --dport 443 -m state --state NEW -j ACCEPT
      netfilter-persistent save
    EOT
    )
  }
}
