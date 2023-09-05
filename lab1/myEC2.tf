provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "myec2" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
  key_name      = "devops"
  tags = {
    name = "ec2-rodriguez"
  }
  root_block_device {
    delete_on_termination = true
  }
}
