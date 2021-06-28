variable "vpc_config" {
  type = object({
    cidr_block       = string
    instance_tenancy = string
    tags             = map(string)
  })
  default = {
    cidr_block       = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
      "Name" = "my-app-ugam"
    }
  }
}

variable "app_name" {
  default = "myapp"
}