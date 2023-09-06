# Terraform-training

Pour chaque lab, se placer à la racine et lancer les commandes suivants

# Previsualiser les ressources avant application sur le cloud provider
terraform plan -out savetf

# Enteriner ou appliquer la creation et valider avec "yes"

terraform apply "savetf"

# supprimer les ressources avec 
terraform destroy
