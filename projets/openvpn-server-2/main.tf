# Fichier laissé volontairement quasi vide.
# Le code est réparti dans les fichiers spécialisés :
#   - versions.tf   : version Terraform et providers requis
#   - providers.tf  : configuration du provider AWS
#   - variables.tf  : déclaration des variables
#   - data.tf       : data sources (AMI, VPC)
#   - security.tf   : security group
#   - ec2.tf        : instance EC2
#   - outputs.tf    : sorties affichées après apply
#
# Terraform charge automatiquement tous les .tf du répertoire,
# l'ordre et le nom des fichiers n'ont pas d'importance technique.