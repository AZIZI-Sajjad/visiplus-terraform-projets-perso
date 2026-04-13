### Basic
```
Le minimum possible
```


### Adv
```
Un petit projet, de création de vps et installation de l'OS
```


### adv-1 : apache-php
```
https://github.com/docker/awesome-compose/tree/master/apache-php
```

### adv-2 : react-express-mysql
```
https://github.com/docker/awesome-compose/tree/master/react-express-mysql

Tests : 
HostName dans la variable : ec2_hostname
App name dans la variable : app_name
```


### adv-3 : wordpress-mysql
```
https://github.com/docker/awesome-compose/tree/master/wordpress-mysql

Test : 
Passer le script d'installation de docker et docker compose un fichier de script en local du serveur terraform

```


### adv-4 : wordpress-mysql
```
https://github.com/docker/awesome-compose/tree/master/wordpress-mysql

Test : 
Passer le script d'installation de docker et docker compose un Template avec des variables sur le serveur terraform
# Script d'installation contenant des variables Terraform, injectées via templatefile() car file() ne fait aucune interpolation
```


---
# Commandes de diagnostique
---

### Vérifier le statut global de cloud-init (done, running, error)

```bash
cloud-init status --long
```

---

### Chercher les erreurs dans les logs cloud-init

```bash
sudo cat /var/log/cloud-init-output.log | grep -A 5 "scripts_user\|Failed\|error"
```

---

### Afficher le contenu du script injecté par Terraform via user_data

```bash
cat /var/lib/cloud/instance/scripts/part-001
```

---

### Vérifier les permissions et la taille du script (doit être exécutable)

```bash
ls -al /var/lib/cloud/instance/scripts/part-001
```

---

### Boucle de monitoring : surveille en temps réel l'installation de Docker et le déploiement des containers

```bash
while true; do
    ps aux | grep -Ei "docker|apt"
    echo "$(printf '%0.s-' {1..11})> DOCKER PS $(printf '%0.s-' {1..14})"
    docker ps
    echo "$(printf '%0.s-' {1..11})> DOCKER IMAGE LS $(printf '%0.s-' {1..14})"
    sudo docker image ls
    printf '%0.s-' {1..133}; echo
    sleep 2
done
```

### Réinitialiser et détruire les environnements Terraform adv-1 à adv-4 
```bash
for dir in adv-{1..4}; do
    echo "========== $dir =========="
    terraform -chdir="./$dir" init -upgrade
    terraform -chdir="./$dir" destroy -var-file="aws.tfvars" -auto-approve
    rm -rf "./$dir/.terraform" "./$dir/.terraform.lock.hcl"
    rm -f "./$dir/terraform.tfstate" "./$dir/terraform.tfstate.backup"
done
```

