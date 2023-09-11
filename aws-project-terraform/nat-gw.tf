## Créer une passerelle nat pour un sous-réseau public et une ip élastique
resource "aws_eip" "eip_public_a" {
  vpc = true
}
resource "aws_nat_gateway" "gw_public_a" {
  allocation_id = aws_eip.eip_public_a.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "rodrigue-nat-public-a"
  }
}
##################################################### FIN


## Créer une table de routage pour app un sous-réseau
resource "aws_route_table" "rtb_appa" {

  vpc_id = aws_vpc.rodrigue_vpc.id
  tags = {
    Name        = "rodrigue-appa-routetable"
    Environment = var.environment
  }

}
##################################################### FIN

#créer une route vers la passerelle nat
resource "aws_route" "route_appa_nat" {
  route_table_id         = aws_route_table.rtb_appa.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw_public_a.id
}


resource "aws_route_table_association" "rta_subnet_association_appa" {
  subnet_id      = aws_subnet.app_subnet_a.id
  route_table_id = aws_route_table.rtb_appa.id
}

##################################################### FIN


## Créer une passerelle Nat et des routes pour le sous-réseau B de l'application
resource "aws_eip" "eip_public_b" {
  vpc = true
}
resource "aws_nat_gateway" "gw_public_b" {
  allocation_id = aws_eip.eip_public_b.id
  subnet_id     = aws_subnet.public_subnet_b.id

  tags = {
    Name = "rodrigue-nat-public-b"
  }
}

resource "aws_route_table" "rtb_appb" {

  vpc_id = aws_vpc.rodrigue_vpc.id
  tags = {
    Name        = "rodrigue-appb-routetable"
    Environment = var.environment
  }
}
resource "aws_route" "route_appb_nat" {
  route_table_id         = aws_route_table.rtb_appb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw_public_b.id
}


resource "aws_route_table_association" "rta_subnet_association_appb" {
  subnet_id      = aws_subnet.app_subnet_b.id
  route_table_id = aws_route_table.rtb_appb.id
}
##################################################### FIN
