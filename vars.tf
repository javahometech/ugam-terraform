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