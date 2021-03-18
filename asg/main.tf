provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_launch_configuration" "emxcel_asg_launch" {
  image_id = "ami-0d729a60"
  instance_type = "t2-micro"
  security_groups = ["aws_security_group.emxcel_asg_sec.id"]
  /*user_data = echo "This instances are of asg" > /var/www/html/paresh.html */

  lifecycle{
    create_before_destroy = true
  }
}

resource "aws_security_group" "emxcel_asg_sec" {
  name = "emxcel-asg-sec"
  vpc_id = "$var.vpc_id"
}

resource "aws_security_group_rule" "emxcel_asg_ssh" {
  from_port = 22
  protocol = "tcp"
  security_group_id = "aws_security_group.emxcel_asg_sec.id"
  to_port = 22
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "emxcel_asg_inbound" {
  from_port = 80
  protocol = "tcp"
  security_group_id = "aws_security_group.emxcel_asg_sec.id"
  to_port = 80
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "emxcel_asg_outbound" {
  from_port = 80
  protocol = "tcp"
  security_group_id = "aws_security_group.emxcel_asg_sec.id"
  to_port = 80
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_autoscaling_group" "emxcel_asg" {
  max_size = 2
  min_size = 10
  launch_configuration = "aws_launch_configuration.emxcel_asg_launch.name"
  vpc_zone_identifier = ["$var.subnet_id"]
  target_group_arns = ["$var.target_group_arn"]
  health_check_type = "ELB"

  tag {
        key = "Name"
        value = "emxcel-asg"
        propagate_at_launch = true
}

}