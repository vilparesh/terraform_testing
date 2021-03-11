output "vpc_identiy" {
  value = "${aws_vpc.emxcel_vpc.id}"
}

output "vpc_internet_gateway" {
  value = "${aws_internet_gateway.emxcel_gateway.id}"
}

output "vpc_security_group" {
  value = "${aws_security_group.emxcel_sec_group.id}"
}

output "vpc_pub_subnet" {
  value = "${aws_subnet.emxcel_public_subnet.*.id}"
}