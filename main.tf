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
  source           = "./ec2"
  instance_pub_key = "/home/paresh/paresh/.ssh/id_rsa.pub"
  security_group   = "module.vpc.vpc_security_group"
  public_subnet    = "module.vpc.vpc_pub_subnet"
}

module "alb" {
  source       = "./alb"
  vpc_id       = "module.vpc.vpc_identiy"
  instance1_id = "module.ec2.inst1_id"
  instance2_id = "module.ec2.inst2_id"
  subnet1      = "module.vpc.subnet1"
  subnet2      = "module.vpc.subnet2"
}

module "asg" {
  source           = "./asg"
  vpc_id           = "module.vpc.vpc_identiy"
  subnet_id        = "module.vpc.vpc_pub_subnet"
  target_group_arn = "module.alb.alb_target_group_arn"
}