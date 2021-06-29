variable "app_name" {
  default = "ugam-api"
}
variable "subnet_ids" {

}
variable "listners" {
  type = map(object({
    instance_port     = number
    instance_protocol = string
    lb_port           = number
    lb_protocol       = string
  }))
  default = {
    "http" = {
      instance_port     = 80
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }
  }
}

variable "health_check" {
  type = object({
    healthy_threshold   = number
    unhealthy_threshold = number
    timeout             = number
    target              = string
    interval            = number
  })
  default = {
    healthy_threshold = 2
    interval = 30
    target = "HTTP:80/"
    timeout = 3
    unhealthy_threshold = 2
  }
}