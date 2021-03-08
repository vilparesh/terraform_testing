#Enter aws region, here we are creating it in mumbai region.
provider "aws" {
        region = "ap-northeast-1"
}

#Zone availability

data "aws_availability_zones" "available" {
     state = "available"
}
#Create VPC 
resource "aws_vpc" "emxcel_vpc" {
        cidr_block = var.cidr_range
        enable_dns_hostnames = "true"
        enable_dns_support = "true"
     
        tags = {
              name = "emxcel-vpc"
             }
}
#Create Internet gateway for VPC
resource "aws_internet_gateway" "emxcel_gateway" {
  vpc_id = "aws_vpc.emxcel_vpc.id"

  tags = {
    name = "emxcel-internet-gateway"
  }
}
#Create public route table
resource "aws_route_table" "emxcel_public_route" {
  vpc_id = aws_vpc.emxcel_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "aws_internet_gateway.emxcel_gateway.id"
  }

  tags = {
    name = "emxcel-public-route"
  }
}

#Create private route table
resource "aws_default_route_table" "emxcel_private_route" {
  default_route_table_id = "aws_vpc.emxcel_vpc.id"

  tags = {
    name = "emxcel-private-route"
  }
}

#Create public subnet
resource "aws_subnet" "emxcel_public_subnet" {
  count = 2
  cidr_block = var.cidrs_public_subnet[count.index]
  vpc_id = aws_vpc.emxcel_vpc.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    name  = "emxcel-public-subnet-$[count.index + 1]"
  }
 }

#Create private subnet
resource "aws_subnet" "emxcel_private_subnet" {
  count = 2
  cidr_block = var.cidrs_private_subnet[count.index]
  vpc_id = aws_vpc.emxcel_vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    name = "emxcel-private-subnet-$[count.index + 1]"
  }
}

#Associate route table to public subnet
resource "aws_route_table_association" "route_table_public" {
  count = 2
  route_table_id = aws_route_table.emxcel_public_route.id
  subnet_id = aws_subnet.emxcel_public_subnet.*.id[count.index]
  depends_on = [aws_route_table.emxcel_public_route,aws_subnet.emxcel_public_subnet]
 }

#Associate default route table to private subnet
resource "aws_route_table_association" "route_table_private" {
  count = 2
  route_table_id = aws_default_route_table.emxcel_private_route.id
  subnet_id = aws_subnet.emxcel_private_subnet.*.id[count.index]
  depends_on = [aws_default_route_table.emxcel_private_route,aws_subnet.emxcel_private_subnet]
}

#Create VPC security group
resource "aws_security_group" "emxcel_sec_group" {
  name = "emxcel-security-group"
  vpc_id = aws_vpc.emxcel_vpc.id

  ingress {
    description = "allow inbound traffic on port 80"
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow inbound traffic on port 443"
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow inbound traffic on port 22"
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}