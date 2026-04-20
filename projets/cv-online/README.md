Et voici la version ultra courte des **commandes vraiment utiles** :

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