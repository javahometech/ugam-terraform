resource "aws_elb" "main" {
  name    = "${var.app_name}-elb-${terraform.workspace}"
  subnets = var.subnet_ids
  security_groups = [aws_security_group.main.id]
  #   access_logs {
  #     bucket        = "foo"
  #     bucket_prefix = "bar"
  #     interval      = 60
  #   }

  dynamic "listener" {
    for_each = var.listners
    content {
      instance_port     = listener.value.instance_port
      instance_protocol = listener.value.instance_protocol
      lb_port           = listener.value.lb_port
      lb_protocol       = listener.value.lb_protocol
    }
  }

  health_check {
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
    timeout             = var.health_check.timeout
    target              = var.health_check.target
    interval            = var.health_check.interval
  }

#   instances                   = [aws_instance.foo.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 60

  tags = {
    Name = "${var.app_name}-elb-${terraform.workspace}"
  }
}

resource "aws_security_group" "main" {
  name        = "${var.app_name}_${terraform.workspace}_elb_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.lb_sg_ingress_rules
    content {
      description = "TLS from VPC"
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidrs
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.app_name}_${terraform.workspace}_elb_sg"
  }
}