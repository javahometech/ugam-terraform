resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0008e34518cb38121"]
  subnets            = ["subnet-0695fe4f65a8431f6", "subnet-0031c509ca7732890"]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}
resource "aws_lb_target_group" "default" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-074888e19e7efeabb"
}

resource "aws_lb_listener" "default" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}

# JIRA story

resource "aws_lb_target_group" "dev_apps" {
  count    = length(var.alb_headers_ports)
  name     = "${var.alb_headers_ports[count.index].app_name}-target-group"
  port     = var.alb_headers_ports[count.index].port
  protocol = "HTTP"
  vpc_id   = "vpc-074888e19e7efeabb"
}

resource "aws_lb_listener_rule" "static" {
  count        = length(var.alb_headers_ports)
  listener_arn = aws_lb_listener.default.arn
#   priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_apps.*.arn[count.index]
  }

  condition {
    host_header {
      values = ["${var.alb_headers_ports[count.index].host_header}"]
    }
  }
}


output "targets" {
  value = aws_lb_target_group.dev_apps
  # value = {for s in var.list : s => upper(s)}
}
