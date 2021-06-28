variable "region" {
  default     = "us-east-1"
  description = "Choose the value for a region"
  type        = string
}
variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "chosse vpc CIDR"
  type        = string
}
variable "vpc_tenancy" {
  default     = "default"
  description = "chosse vpc tenancy"
  type        = string
}

variable "web_amis" {
  type = map(string)
  default = {
    us-east-1 = "ami-0ab4d1e9cf9a1215a"
    us-east-2 = "ami-0277b52859bac6f4b"
  }
}

variable "ugam_api_bucket" {
  default = "ugam-api-dev"
  type    = string
}

variable "vpc" {
  type = object({
    cidr    = string
    tenancy = string
    tags    = map(string)
  })
  default = {
    cidr = "10.0.0.0/16"
    tags = {
      "Name"     = "ugam-vpc-one"
      "Locatoin" = "Mumbai"
    }
    tenancy = "default"
  }
}

# Map of object

variable "vpcs" {
  type = map(object({
    cidr    = string
    tenancy = string
    tags    = map(string)
  }))
  default = {
    "vpc-one" = {
      cidr = "10.0.0.0/16"
      tags = {
        "key" = "vpc-one"
      }
      tenancy = "default"
    }
    "vpc-two" = {
      cidr = "10.20.0.0/16"
      tags = {
        "key" = "vpc-two"
      }
      tenancy = "default"
    }
  }
}

variable "web_ingress" {
  type = map(object({
    from_port   = number
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = {
    "22" = {
      cidr_blocks = ["172.20.0.0/16"]
      from_port   = 22
      to_port     = 22
    }
    "80" = {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 80
      to_port     = 80
    }
  }
}
