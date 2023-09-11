# Créer une passerelle Internet pour notre VPC
resource "aws_internet_gateway" "rodrigue_igateway" {
  vpc_id = aws_vpc.rodrigue_vpc.id

  tags = {
    Name        = "rodrigue-igateway"
    Environment = var.environment
  }

  depends_on = [aws_vpc.rodrigue_vpc]
}

# Créez une table de routage afin que nous puissions attribuer un sous-réseau public-a et public-b à cette table de routage
resource "aws_route_table" "rtb_public" {

  vpc_id = aws_vpc.rodrigue_vpc.id
  tags = {
    Name        = "rodrigue-public-routetable"
    Environment = var.environment
  }

  depends_on = [aws_vpc.rodrigue_vpc]
}

# Créez une route dans la table de routage, pour accéder au public via une passerelle Internet
resource "aws_route" "route_igw" {
  route_table_id         = aws_route_table.rtb_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.rodrigue_igateway.id

  depends_on = [aws_internet_gateway.rodrigue_igateway]
}

# Ajouter un sous-réseau public-a à la table de routage
resource "aws_route_table_association" "rta_subnet_association_puba" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.rtb_public.id

  depends_on = [aws_route_table.rtb_public]
}

# Ajouter un sous-réseau public-b à la table de routage
resource "aws_route_table_association" "rta_subnet_association_pubb" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.rtb_public.id

  depends_on = [aws_route_table.rtb_public]
}