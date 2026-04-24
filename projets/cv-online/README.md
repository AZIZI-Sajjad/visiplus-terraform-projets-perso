Et voici la version ultra courte des **commandes vraiment utiles** :

```bash
# Using Gitlab CICD variables in Terrform

https://medium.com/@amittidke/using-gitlab-cicd-variables-in-terrform-a21c011faa0a
```


```bash
# Vérification
docker --version
docker compose version

# Terraform via Docker
sudo docker run --rm -it -v "$PWD:/workspace" -w /workspace hashicorp/terraform:latest init
sudo docker run --rm -it -v "$PWD:/workspace" -w /workspace hashicorp/terraform:latest plan -var-file="aws.tfvars"
sudo docker run --rm -it -v "$PWD:/workspace" -w /workspace hashicorp/terraform:latest destroy -var-file="aws.tfvars"

# Docker Compose
sudo docker compose --file ./docker-compose.yml --project-name hashicorp-terraform config
sudo docker compose --file ./docker-compose.yml --project-name hashicorp-terraform up -d
sudo docker compose --file ./docker-compose.yml --project-name hashicorp-terraform logs
sudo docker compose --file ./docker-compose.yml --project-name hashicorp-terraform down
```

```bash
# Git clone via SSH en précisant la clé privée SSH
git clone -c "core.sshCommand=ssh  -i ~/.ssh/aws-ci-cd-deploy-gitlab.com" git@gitlab.com:AZIZI-Sajjad/cv.git

sync -e " ssh -i ~/.ssh/aws-ci-cd-deploy" ubuntu@15.236.207.137:/home/ubuntu/cv.
zip .

```

```bash
#Commentaires

# SSH:
Clé publique dans le serveur distant ssh-copy-id
# Gitlab:
Clé publique dans github

# À faire : 
Transmettre la clé privée de ssh de Gitlab dans le VPS EC2 de AWS
Avec Terraform ?
OU avec Gitla

```

```bash
# Créer le répertoire de destination
sudo mkdir -p "${deploy_directory}"

# Copier les fichiers compilés
sudo rsync -av --delete "${build_directory}/" "${deploy_directory}/"
```


```bash
sed -i 's/[[:space:]]\+$//' src/components/Skills.vue
sed -i '2c\  <q-timeline :layout="print || layout">' src/components/Timeline.vue
sed -i 's/extendWebpack (cfg)/extendWebpack ()/' quasar.conf.js
sed -i -e '$a\' src/i18n/en-US/index.js
sed -i -e '$a\' src/i18n/fr-FR/index.js
```

```bash
while true; do
    ps aux | grep -Ei "git|apt|npm"
    printf '%0.s-' {1..133}; echo
    ss -tulpn | grep 1194
    printf '%0.s-' {1..133}; echo
    sudo /home/ubuntu/openvpn-install/openvpn-install.sh client list
    printf '%0.s-' {1..133}; echo
    sleep 2
done
```
