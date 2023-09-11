resource "aws_vpc" "rodrigue_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "rodrigue-vpc",
    Environment = var.environment
  }
}


resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.rodrigue_vpc.id
  cidr_block              = var.cidr_public_subnet_a
  map_public_ip_on_launch = "true"
  availability_zone       = var.az_a

  tags = {
    Name        = "public-a",
    Environment = var.environment
  }

  depends_on = [aws_vpc.rodrigue_vpc]
}


resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.rodrigue_vpc.id
  cidr_block              = var.cidr_public_subnet_b
  map_public_ip_on_launch = "true"
  availability_zone       = var.az_b

  tags = {
    Name        = "public-b",
    Environment = var.environment
  }
  depends_on = [aws_vpc.rodrigue_vpc]
}

### Créer 2 sous-réseaux privées pour les serveurs lewis
resource "aws_subnet" "app_subnet_a" {

  vpc_id                  = aws_vpc.rodrigue_vpc.id
  cidr_block              = var.cidr_app_subnet_a
  map_public_ip_on_launch = "true"
  availability_zone       = var.az_a

  tags = {
    Name        = "app-a",
    Environment = var.environment
  }
  depends_on = [aws_vpc.rodrigue_vpc]
}


resource "aws_subnet" "app_subnet_b" {

  vpc_id                  = aws_vpc.rodrigue_vpc.id
  cidr_block              = var.cidr_app_subnet_b
  map_public_ip_on_launch = "true"
  availability_zone       = var.az_b

  tags = {
    Name        = "app-b",
    Environment = var.environment
  }
  depends_on = [aws_vpc.rodrigue_vpc]
}
