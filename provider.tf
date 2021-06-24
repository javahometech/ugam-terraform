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
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.vpc_tenancy

  tags = {
    Name     = "ugam-vpc-${terraform.workspace}"
    Location = "Banglore"
    AccountId = data.aws_caller_identity.current.account_id
  }
}

# create multiple subnets under main vpc
resource "aws_subnet" "main" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "public-subnet"
  }
}
