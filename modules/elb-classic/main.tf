resource "aws_elb" "main" {
  name    = "${var.app_name}-elb-${terraform.workspace}"
  subnets = var.subnet_ids

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