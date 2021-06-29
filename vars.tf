variable "region" {
  default = "us-east-1"
}

variable "web_sg_ingress" {
  type = map(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    "80" = {
      cidr_blocks = ["0.0.0.0/0"]
      port        = 80
      protocol    = "tcp"
    }
    "22" = {
      cidr_blocks = ["0.0.0.0/0"]
      port        = 22
      protocol    = "tcp"
    }
  }
}