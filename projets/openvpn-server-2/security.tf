# Création du security group du serveur applicatif
resource "aws_security_group" "app_server_live_sg" {
  # Nom du security group
  name = var.ec2_hostname

  # Description du security group
  description = "allow inbound traffic on port SSH & openvpn 1194 and allow all outbound"

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

  # Autoriser port openvpn (port TCP ${var.openvpn_port}) depuis n'importe quelle IP
  ingress {
    # Description de la règle
    description = "Allow openvpn (port TCP ${var.openvpn_port}) from any ip adress"

    # Port source
    from_port = var.openvpn_port

    # Port destination
    to_port = var.openvpn_port

    # Protocole utilisé
    protocol = "tcp"

    # Autoriser depuis toutes les IP
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Description de la règle
    description = "Allow openvpn (port UDP ${var.openvpn_port}) from any ip adress"

    # Port source
    from_port = var.openvpn_port

    # Port destination
    to_port = var.openvpn_port

    # Protocole utilisé
    protocol = "udp"

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

}

# 