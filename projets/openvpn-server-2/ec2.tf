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

## Encoder le script en  pour AWSopenvpn_clients
  user_data = templatefile("${path.module}/templates/install-openvpn-server.sh", {
    openvpn_clients = var.openvpn_clients
    ec2_hostname = var.ec2_hostname
    openvpn_port = var.openvpn_port
    })

  # Tags de l'instance
  tags = {
    # Nom affiché dans AWS pour l'instance
    Name = var.ec2_hostname
  }
}

# 