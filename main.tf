provider "aws" {
          region = "ap-northeast-1"
}

module "vpc" {
  source               = "./vpc"
  cidr_range           = var.cidr_range
  cidrs_public_subnet  = var.cidrs_public_subnet
  cidrs_private_subnet = var.cidrs_private_subnet
}

