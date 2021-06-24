provider "aws" {
  region = "us-east-1"
  profile = "default"
}

terraform {
  backend "s3" {
    bucket = "terrafom-ugam-demo"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "ugam-tf-lock"
  }
}


resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ugam-vpc"
    Location = "Banglore"
  }
}