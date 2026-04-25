Et voici la version ultra courte des **commandes vraiment utiles** :

```bash
# Using Gitlab CICD variables in Terrform

https://medium.com/@amittidke/using-gitlab-cicd-variables-in-terrform-a21c011faa0a
```

```bash
## ----------------------------------------------------------------
## Explication de la boucle, étape par étape
## ----------------------------------------------------------------
echo "$CLIENTS_JSON" | jq -c '.[]' | while read -r client; do
  username=$(echo "$client" | jq -r '.username')
  password=$(echo "$client" | jq -r '.password')
  MENU_OPTION=1 CLIENT="$username" PASS=2 PASSWORD="$password" ./openvpn-install.sh
done


## Point de départ: CLIENTS_JSON contient une chaîne JSON du type
## [{"username":"user1","password":"pass1"},{"username":"user2","password":"pass2"},...]
## C'est Terraform qui l'a injectée via jsonencode(openvpn_clients).

CLIENTS_JSON='[{"username":"user1","password":"pass1"},{"username":"user2","password":"pass2"}]'

## ----------------------------------------------------------------
## Étape 1: echo "$CLIENTS_JSON"
## ----------------------------------------------------------------
## Envoie le JSON complet sur la sortie standard (stdout)
## pour qu'on puisse le passer à jq via un pipe |

## ----------------------------------------------------------------
## Étape 2: | jq -c '.[]'
## ----------------------------------------------------------------
## jq = parseur JSON en ligne de commande
## '.[]' = itère sur tous les éléments du tableau racine
## -c   = "compact", sort chaque objet sur UNE SEULE ligne
##
## Résultat en sortie:
##   {"username":"user1","password":"pass1"}
##   {"username":"user2","password":"pass2"}
##
## Chaque objet devient une ligne indépendante, prête à être lue.

## ----------------------------------------------------------------
## Étape 3: while read -r client; do ... done
## ----------------------------------------------------------------
## read -r    = lit UNE ligne depuis stdin et la stocke dans $client
##              l'option -r évite que le backslash soit interprété
## while ...  = continue tant qu'il reste des lignes à lire
##
## À chaque tour de boucle, $client contient un objet JSON:
##   Tour 1: client='{"username":"user1","password":"pass1"}'
##   Tour 2: client='{"username":"user2","password":"pass2"}'

## ----------------------------------------------------------------
## Étape 4: extraction des champs avec jq -r
## ----------------------------------------------------------------
username=$(echo "$client" | jq -r '.username')
password=$(echo "$client" | jq -r '.password')

## jq -r = "raw", sort la valeur SANS guillemets JSON autour
## Sans -r on aurait username='"user1"' au lieu de username='user1'
## $(...) = command substitution, capture la sortie dans la variable

## ----------------------------------------------------------------
## Étape 5: appel du script angristan avec les variables d'env
## ----------------------------------------------------------------
## MENU_OPTION=1  -> choix "add client" dans le menu du script
## CLIENT=...     -> nom du client à créer
## PASS=2         -> choix "mot de passe protégé" (au lieu de passwordless)
## PASSWORD=...   -> mot de passe à utiliser
##
## Ces variables sont passées UNIQUEMENT à ce process (pas exportées globalement)
## C'est la façon dont angristan permet de scripter son installeur sans interaction.

## ----------------------------------------------------------------
## Résumé en une phrase
## ----------------------------------------------------------------
## On transforme un tableau JSON en lignes séparées, on lit chaque ligne
## une par une, on en extrait username/password, et on appelle le script
## OpenVPN avec ces valeurs pour créer chaque client automatiquement.
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
    sudo ss -tulpn | grep -Ei "443|1191"
    printf '%0.s-' {1..133}; echo
    sudo /home/ubuntu/openvpn-install/openvpn-install.sh client list
    sleep 2
done
```
