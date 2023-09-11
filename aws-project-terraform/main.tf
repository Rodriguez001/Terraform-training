data "aws_ami" "rodrigue-ami" { # déclaration de la source de données de type aws_ami (ami aws)
  most_recent = true            # demande à avoir l'image la plus recente disponible
  owners      = ["amazon"]      # lorsque le proriétaire de l'image s'appele amazon
  filter {                      # on ajoute un filtre  
    name   = "name"             # on veut filtrer l'image lorsque le nom à comme par amzn2-ami-hvm- , * pour n'importe quoi , et se termine par -x86_64-gp2
    values = ["amzn2-ami-hvm-*"]
  }
}

## Création de serveurs rodrigue pour le sous-réseau d'application A
resource "aws_security_group" "sg_rodrigue" {
  name   = "sg_rodrigue"
  vpc_id = aws_vpc.rodrigue_vpc.id
  tags = {
    Name        = "sg-rodrigue"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "allow_all" {
  type              = "ingress"
  cidr_blocks       = ["10.1.0.0/24"]
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg_rodrigue.id
}

resource "aws_security_group_rule" "outbound_allow_all" {
  type = "egress"

  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg_rodrigue.id
}

## Création du serveur rodrigue pour le sous-réseau d'application A
resource "aws_instance" "rodrigue_a" {
  ami                    = data.aws_ami.rodrigue-ami.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.app_subnet_a.id
  vpc_security_group_ids = ["${aws_security_group.sg_rodrigue.id}"]
  #key_name               = "${aws_key_pair.myec2key.key_name}"
  user_data = file("install_wordpress.sh")
  tags = {
    Name        = "rodrigue-a"
    Environment = var.environment
  }
}

## Fin 

## Création de serveur rodrigue pour le sous-réseau d'application B

resource "aws_instance" "rodrigue_b" {
  ami                    = data.aws_ami.rodrigue-ami.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.app_subnet_b.id
  vpc_security_group_ids = ["${aws_security_group.sg_rodrigue.id}"]
  #key_name               = "${aws_key_pair.myec2key.key_name}"
  user_data = file("install_wordpress.sh")
  tags = {
    Name        = "rodrigue-b"
    Environment = var.environment
  }

}
## Fin
