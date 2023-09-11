terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# la région aws ou nous voulons déployer nos différentes ressources
provider "aws" {
  region = "us-east-1"
  # access_key = var.access_key # la clé d'acces crée pour l'utilisateur qui sera utilisé par terraform
  # secret_key = var.secret_key # la clé sécrète crée pour l'utilisateur qui sera utilisé par terraform
}

