provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-backend-rodrigue"
    key    = "rodrigue-dev.tfstate"
    region = "us-east-1"
  }
}

module "ec2" {
  source       = "../modules/ec2module"
  instancetype = "t2.nano"
  aws_common_tag = {
    Name : "ec2-dev-rodrigue"
  }
  sg_name = "dev-rodrigue-sg"
}