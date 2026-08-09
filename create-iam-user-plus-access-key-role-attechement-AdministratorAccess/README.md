
## Source : 
```bash
https://oneuptime.com/blog/post/2026-02-23-how-to-create-iam-users-with-terraform/view
```

## Récuperer les informations de al clé d'accès
```bash
# (secret_access_key + access_key_id)
terraform output -raw secret_access_key
terraform output -raw access_key_id
```
## Résoudre une valeur à chaud
```bash
terraform console
# > data.aws_iam_policy.administrator_access.arn
# "arn:aws:iam::aws:policy/AdministratorAccess"
# exit
```

## Le code est-il sur le disque ?
```bash
grep -n "admin_access_attach" iam_user.tf
```

## Ce que Terraform gère déjà
```bash
terraform state list
```

## Ce qui va changer
```bash
terraform plan -var-file=aws.tfvars
```

# Vérif côté AWS
```bash
aws iam list-attached-user-policies --user-name saz-iam-test
```

