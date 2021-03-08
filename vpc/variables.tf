variable cidr_range {
         default = "172.16.0.0/16"
}

variable cidrs_public_subnet {
  type = list
  default = ["172.16.1.0/24","172.16.2.0/24"]
}

variable cidrs_private_subnet {
  type = list
  default = ["172.16.3.0/24","172.16.4.0/24"]
}