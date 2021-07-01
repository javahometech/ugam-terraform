resource "aws_launch_configuration" "app_launch" {
  name            = "${var.app_name}_${terraform.workspace}_launch_config"
  image_id        = var.launch_config.image_id
  instance_type   = var.launch_config.instance_type
  key_name        = var.launch_config.key_name
  security_groups = [aws_security_group.main.id]
  user_data       = var.launch_config.user_data
  associate_public_ip_address = true
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

resource "aws_autoscaling_group" "main" {
  name                      = "${var.app_name}_${terraform.workspace}_asg"
  max_size                  = var.asg_config.max_size
  min_size                  = var.asg_config.min_size
  health_check_grace_period = var.asg_config.health_check_grace_period
  health_check_type         = var.asg_config.health_check_type
  desired_capacity          = var.asg_config.desired_capacity
  force_delete              = var.asg_config.force_delete
  launch_configuration      = aws_launch_configuration.app_launch.name
  load_balancers            = var.load_balancers
  vpc_zone_identifier       = var.subnet_ids
  
  tag {
    key                 = "Name"
    value               = "${var.app_name}_${terraform.workspace}"
    propagate_at_launch = true
  }

  timeouts {
    delete = var.timeouts
  }
}

# Create A policy for auto scaling

resource "aws_autoscaling_policy" "instances" {
  for_each = var.asg_policies
  name                   = "${var.app_name}_${terraform.workspace}_${each.key}"
  scaling_adjustment     = each.value.scaling_adjustment
  adjustment_type        = each.value.adjustment_type
  cooldown               = each.value.cooldown
  autoscaling_group_name = aws_autoscaling_group.main.name
}

resource "aws_cloudwatch_metric_alarm" "instances" {
  for_each = aws_autoscaling_policy.instances
  alarm_name          = "terraform-test-foobar5-${each.key}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [each.value.arn]
}