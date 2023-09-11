variable "cidr_vpc" {
  description = "CIDR du VPC"
  default     = "10.1.0.0/16"

}

variable "environment" {
  description = "l'Environnement de déploiements de nos resources"
  default     = "Prod"
  type        = string
}

variable "cidr_public_subnet_a" {
  description = "CIRD Sous-réseau  public A"
  default     = "10.1.0.0/24"

}

variable "cidr_public_subnet_b" {
  description = "CIRD Sous-réseau  public B"
  default     = "10.1.1.0/24"

}

variable "cidr_app_subnet_a" {
  description = "CIRD Sous-réseau privé A"
  default     = "10.1.2.0/24"

}

variable "cidr_app_subnet_b" {
  description = "CIRD Sous-réseau privé B"
  default     = "10.1.3.0/24"

}

variable "az_a" {
  description = "Sous-réseau du sous-réseau public"
  default     = "us-east-1a"
}


variable "az_b" {
  description = "Sous-réseau du sous-réseau public"
  default     = "us-east-1b"

}
