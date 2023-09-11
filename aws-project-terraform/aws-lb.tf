## Création d'un équilibreur de charge d'application pour accéder à l'application
resource "aws_security_group" "sg_application_lb" {

  name   = "sg_application_lb"
  vpc_id = aws_vpc.rodrigue_vpc.id

  ingress {
    # TLS (change to whatever ports you need)
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    # Veuillez limiter votre entrée aux seules adresses IP et ports nécessaires.
    # L'ouverture à 0.0.0.0/0 peut entraîner des failles de sécurité.
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }

}


resource "aws_lb" "lb_rodrigue" {
  name               = "rodrigue-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["${aws_subnet.public_subnet_a.id}", "${aws_subnet.public_subnet_b.id}"]
  security_groups    = ["${aws_security_group.sg_application_lb.id}"]

  enable_deletion_protection = false



  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb_rodrigue.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rodrigue_vms.arn
  }
}

resource "aws_lb_target_group" "rodrigue_vms" {
  name     = "tf-rodrigue-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.rodrigue_vpc.id
}

## Joindre les instances attachées à la zone de disponibilté A au groupe cible
resource "aws_lb_target_group_attachment" "rodriguea_tg_attachment" {
  target_group_arn = aws_lb_target_group.rodrigue_vms.arn
  target_id        = aws_instance.rodrigue_a.id

  port = 80
}


## Joindre les instances attachées à la zone de disponibilté B au groupe cible
resource "aws_lb_target_group_attachment" "rodrigueb_tg_attachment" {
  target_group_arn = aws_lb_target_group.rodrigue_vms.arn
  target_id        = aws_instance.rodrigue_b.id
  port             = 80
}
