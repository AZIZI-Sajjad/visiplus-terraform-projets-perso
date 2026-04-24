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

## Installer git
apt-get update
apt-get install -y git openssh-client nodejs npm

## Créer le répertoire SSH
mkdir -p /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh

## Ajouter la clé privée
cat > /home/ubuntu/.ssh/gitlab_rsa << 'SSHKEY'
${private_key}
SSHKEY
chmod 600 /home/ubuntu/.ssh/gitlab_rsa

## Enregistrer GitLab
ssh-keyscan -H gitlab.com >> /home/ubuntu/.ssh/known_hosts 2>/dev/null

## Permissions
chown -R ubuntu:ubuntu /home/ubuntu/.ssh


cd /home/ubuntu/
sudo -u ubuntu git clone -c "core.sshCommand=ssh -i /home/ubuntu/.ssh/gitlab_rsa" ${gitlab_repo_url}

# Installation de l'application :
cd ${project_directory}
# sed -i 's/[[:space:]]\+$//' src/components/Skills.vue
# sed -i '2c\  <q-timeline :layout="print || layout">' src/components/Timeline.vue
# sed -i 's/extendWebpack (cfg)/extendWebpack ()/' quasar.conf.js
# sed -i -e '$a\' src/i18n/en-US/index.js
# sed -i -e '$a\' src/i18n/fr-FR/index.js

# Installer les dépendances
npm install

# Vérifier le lint
npm run lint

# Compiler le projet
# NODE_OPTIONS=--openssl-legacy-provider npm run build
NODE_OPTIONS=--openssl-legacy-provider npx quasar build

# Fixer les permissions
sudo chown -R www-data:www-data "${deploy_directory}"

# Lancer l'application
cd "${build_directory}"
python3 -m http.server 8080

