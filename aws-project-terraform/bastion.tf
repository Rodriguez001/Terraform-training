## Création du serveur  Bastion 

#resource "aws_key_pair" "myec2key" {
# key_name   = "rodrigue_keypair"
#public_key = "${file("~/.ssh/id_rsa.pub")}"
#}

resource "aws_security_group" "sg_22" {

  name   = "sg_22"
  vpc_id = aws_vpc.rodrigue_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "sg-22"
    Environment = var.environment
  }
}


# Créer un NACL pour accéder à l'hôte bastion via le port 22
resource "aws_network_acl" "rodrigue_public_a" {
  vpc_id = aws_vpc.rodrigue_vpc.id

  subnet_ids = ["${aws_subnet.public_subnet_a.id}"]

  tags = {
    Name        = "acl-rodrigue-public-a"
    Environment = var.environment
  }
}

resource "aws_network_acl_rule" "nat_inbounda" {
  network_acl_id = aws_network_acl.rodrigue_public_a.id
  rule_number    = 200
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  # L'ouverture à 0.0.0.0/0 peut entraîner des failles de sécurité. vous devez restreindre uniquement l'acces à votre ip publique
  cidr_block = "0.0.0.0/0"
  from_port  = 0
  to_port    = 0
}

resource "aws_network_acl_rule" "nat_inboundb" {
  network_acl_id = aws_network_acl.rodrigue_public_a.id
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  # L'ouverture à 0.0.0.0/0 peut entraîner des failles de sécurité. vous devez restreindre uniquement l'acces à votre ip publique
  cidr_block = "0.0.0.0/0"
  from_port  = 0
  to_port    = 0
}
# Créer un NACL pour accéder à l'hôte bastion via le port 22

resource "aws_instance" "rodrigue_bastion" {
  ami                    = data.aws_ami.rodrigue-ami.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_a.id
  vpc_security_group_ids = ["${aws_security_group.sg_22.id}"]
  #key_name               = "${aws_key_pair.myec2key.key_name}"

  tags = {
    Name        = "rodrigue-bastion"
    Environment = var.environment
  }

}
