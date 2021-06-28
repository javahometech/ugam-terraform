provider "aws" {
  region  = var.region
  profile = "default"
}

terraform {
  backend "s3" {
    bucket         = "terrafom-ugam-demo"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ugam-tf-lock"
  }
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc.cidr
  instance_tenancy = var.vpc.tenancy
  tags             = var.vpc.tags
}

# create multiple subnets under main vpc
# resource "aws_subnet" "main" {
#   count             = length(local.az_names)
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index)
#   availability_zone = element(local.az_names, count.index)
#   tags = {
#     Name = "public-subnet"
#   }
# }
