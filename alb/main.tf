provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_lb_target_group" "emxcel_lb_target_group" {
  health_check {
    interval = 10
    path = "/"
    protocol = "HTTP"
    timeout = 5
    healthy_threshold = 5
    unhealthy_threshold = 2
  }
  name = "emxcel-lb-target-group"
  port  = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = "$var.vpc_id"
}

resource "aws_alb_target_group_attachment" "emxcel_albtgt_attachment1" {
  target_group_arn = aws_lb_target_group.emxcel_lb_target_group.arn
  target_id = "$var.instance1_id"
  port = 80
}

resource "aws_alb_target_group_attachment" "emxcel_albtgt_attachment2" {
  target_group_arn = aws_lb_target_group.emxcel_lb_target_group.arn
  target_id = "$var.instance2_id"
  port = 80
}

resource "aws_lb" "emxcel-alb" {
  name = "emxcel-alb"
  internal = false

  security_groups = ["$(aws_security_group.emxcel_alb_sec.id)"]
  subnets = ["$var.subnet1","$var.subnet2"]

  tags = {
    name = "emxcel-alb"
  }

  ip_address_type = "ipv4"
  load_balancer_type = "application"
}

resource "aws_security_group" "emxcel_albsec_grp" {
  name = "emxcel-albsec-grp"
  vpc_id = "$var.vpc_id"
}

resource "aws_security_group_rule" "alb_inbound" {
  from_port = 80
  protocol = "tcp"
  security_group_id = "aws_security_group. emxcel_albsec_grp.id"
  to_port = 80
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_outbound" {
  from_port = 80
  protocol = "-1"
  security_group_id = "aws_security_group. emxcel_albsec_grp.id"
  to_port = 80
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_lb_listener" "emxcel_lb_listener" {
  load_balancer_arn = aws_lb.emxcel-alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.emxcel_lb_target_group.arn

  }
}