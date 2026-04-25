#!/bin/bash

# cloud-init exécute ce script au premier boot de l'instance
# à ce moment le réseau peut ne pas être encore opérationnel
# et apt peut être verrouillé par unattended-upgrades qui tourne en arrière-plan
# sans ces gardes le script plante silencieusement et cloud-init remonte une erreur


# Attendre que le réseau soit dispo
until ping -c1 archive.ubuntu.com &>/dev/null; do
  sleep 2
done

# Attendre que le lock apt soit libéré
while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
  sleep 2
done


hostnamectl set-hostname ${ec2_hostname}
echo "127.0.1.1 ${ec2_hostname}" >> /etc/hosts
sudo apt update
sudo apt install -y docker.io git curl


cd /home/ubuntu/
git clone https://github.com/angristan/openvpn-install.git
cd openvpn-install
## Installation du serveur OpenVPN en mode non-interactif avec le port tcp 443
export AUTO_INSTALL=y
sudo ./openvpn-install.sh install --protocol tcp --port ${openvpn_port}

## Liste des clients injectée par Terraform via templatefile + jsonencode
CLIENTS_JSON='${jsonencode(openvpn_clients)}'

## Boucle sur chaque client pour générer son profil .ovpn avec mot de passe
echo "$CLIENTS_JSON" | jq -c '.[]' | while read -r client; do
  username=$(echo "$client" | jq -r '.openvpn_username')
  password=$(echo "$client" | jq -r '.openvpn_password')
  ./openvpn-install.sh client add "$username" --password "$password"
done


sudo mkdir /home/ubuntu/openvpn-config-file
cd /home/ubuntu/openvpn-config-file
sudo cp /root/*.ovpn .
