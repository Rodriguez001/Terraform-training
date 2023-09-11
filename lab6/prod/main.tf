provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-backend-rodrigue"
    key = "rodrigue-prod.tfstate"
    region = "us-east-1"
  }
}

module "ec2" {
    source = "../modules/ec2module"  
    instancetype = "t2.micro"
    aws_common_tag = {
        Name : "ec2-prod-rodrigue"
    }
    sg_name = "prod-rodrigue-sg"
}