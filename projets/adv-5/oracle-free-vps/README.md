# Oracle Cloud Free Tier VPS - Terraform

Déploiement automatisé d'un VPS Always Free chez Oracle Cloud (VM.Standard.E2.1.Micro).

## Ressources créées

- 1 VCN (10.0.0.0/16)
- 1 Internet Gateway
- 1 Route Table avec route par défaut
- 1 Security List (SSH 22, HTTP 80, HTTPS 443, ICMP)
- 1 Subnet public (10.0.1.0/24)
- 1 Instance Compute Ubuntu 22.04 (Always Free)

## Prérequis

- Compte Oracle Cloud (gratuit)
- Terraform >= 1.5.0
- Une paire de clés API OCI (générée dans Profile > User Settings > API Keys)
- Une paire de clés SSH pour se connecter à l'instance

## Génération des clés

Clé SSH pour l'instance :
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/oracle_vps
```

Clé API OCI (si tu n'en as pas) :
```bash
mkdir -p ~/.oci
openssl genrsa -out ~/.oci/oci_api_key.pem 2048
chmod 600 ~/.oci/oci_api_key.pem
openssl rsa -pubout -in ~/.oci/oci_api_key.pem -out ~/.oci/oci_api_key_public.pem
```

Puis copier le contenu de `oci_api_key_public.pem` dans la console Oracle Cloud
(Profile > User Settings > API Keys > Add API Key > Paste Public Key).
Récupérer le fingerprint affiché.

## Configuration

```bash
cp terraform.tfvars.example terraform.tfvars
# Éditer terraform.tfvars avec tes valeurs
```

## Déploiement

```bash
terraform init
terraform plan
terraform apply
```

## Connexion à l'instance

```bash
ssh -i ~/.ssh/oracle_vps ubuntu@<public_ip_affichée>
```

## Destruction

```bash
terraform destroy
```

## Variante ARM (plus de ressources)

Pour utiliser le shape ARM A1.Flex (jusqu'à 4 OCPU / 24 Go RAM cumulés sur le tier gratuit),
remplacer dans `compute.tf` :

```hcl
shape = "VM.Standard.A1.Flex"

shape_config {
  ocpus         = 2
  memory_in_gbs = 12
}
```

Et dans le data source images :
```hcl
shape = "VM.Standard.A1.Flex"
```

Attention : capacité ARM souvent saturée selon les régions (erreur "Out of capacity").

## Points d'attention

- Le pare-feu local iptables sur l'image Oracle est restrictif par défaut, le user_data
  ouvre les ports 80 et 443 en plus du 22 déjà autorisé.
- Les règles Security List OCI ET iptables doivent être cohérentes pour qu'un flux passe.
- Always Free = 2 instances E2.1.Micro max par tenancy.
