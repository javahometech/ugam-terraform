variable "launch_config" {
  type = object({
    image_id      = string
    instance_type = string
    key_name      = string
    user_data     = string
  })
}
variable "app_name" {
  default = "ugam"
}
variable "lb_sg_ingress_rules" {
  type = map(object({
    port     = string
    protocol = string
    cidrs    = list(string)
  }))
  default = {
    "80" = {
      cidrs    = ["0.0.0.0/0"]
      port     = "80"
      protocol = "tcp"
    }
  }
}
variable "vpc_id" {
  type = string
}

variable "asg_config" {
  type = object({
    max_size                  = number
    min_size                  = number
    health_check_grace_period = number
    health_check_type         = string
    desired_capacity          = number
    force_delete              = bool
  })
  default = {
    desired_capacity          = 1
    force_delete              = false
    health_check_grace_period = 30
    health_check_type         = "ELB"
    max_size                  = 2
    min_size                  = 1
  }
}

variable "timeouts" {
  default = "15m"
}

variable "subnet_ids" {
  
}

variable "load_balancers" {
  type = list(string)
}

variable "asg_policies" {
  type = map(object({
      scaling_adjustment = number
      adjustment_type = string
      cooldown = number
  }))
  default = {
    "add" = {
      adjustment_type = "ChangeInCapacity"
      cooldown = 30
      scaling_adjustment = 1
    }
    "remove" = {
      adjustment_type = "ChangeInCapacity"
      cooldown = 30
      scaling_adjustment = -1
    }
  }
}