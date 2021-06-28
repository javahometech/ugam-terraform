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