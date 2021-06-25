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
    cidr = string
    tenancy = string
    tags = map(string)
  })
  default = {
    cidr = "10.0.0.0/16"
    tags = {
      "Name" = "ugam-vpc-one"
      "Locatoin" = "Mumbai"
    }
    tenancy = "default"
  }
}