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


hostnamectl set-hostname wordpress-mysql
echo "127.0.1.1 wordpress-mysql" >> /etc/hosts
sudo apt update
sudo apt install -y docker.io git curl

# install docker compose
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.39.3/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose

# access to docker compose from current user
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
sudo chown root:root /usr/local/lib/docker/cli-plugins/docker-compose
sudo usermod -aG docker ubuntu

# get project
cd /home/ubuntu/
git clone https://github.com/docker/awesome-compose.git
cd awesome-compose/wordpress-mysql

# Demarrer le compose
sudo -u ubuntu docker compose -f ./compose.yaml up -d