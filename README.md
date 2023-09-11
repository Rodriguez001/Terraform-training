# Terraform-training

Pour chaque lab, se placer à la racine et lancer les commandes suivants
# Initialisation du projet terraform
terraform init

# Previsualiser les ressources avant application sur le cloud provider
terraform plan -out savetf

# Enteriner ou appliquer la creation

terraform apply "savetf"

# supprimer les ressources 
terraform destroy
