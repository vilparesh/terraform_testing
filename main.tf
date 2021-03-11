provider "aws" {
          region = "ap-northeast-1"
}

module "vpc" {
  source               = "./vpc"
  cidr_range           = var.cidr_range
  cidrs_public_subnet  = var.cidrs_public_subnet
  cidrs_private_subnet = var.cidrs_private_subnet
}
module "ec2" {
  source = "./ec2"
  instance_pub_key = "/home/paresh/paresh/.ssh/id_rsa.pub"
  security_group = "module.vpc.vpc_security_group"
  public_subnet = "module.vpc.vpc_pub_subnet"
}
