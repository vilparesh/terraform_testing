output "vpc_identiy" {
  value = "${aws_vpc.emxcel_vpc.id}"
}

output "vpc_internet_gateway" {
  value = "${aws_internet_gateway.emxcel_gateway.id}"
}

