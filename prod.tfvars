vpc_cidr        = "10.20.0.0/16"
region          = "us-east-2"
vpc_tenancy     = "default"
ugam_api_bucket = "ugam-api-prod"
web_ingress = {
  "22" = {
    cidr_blocks = ["172.20.0.0/16"]
    from_port   = 22
    to_port     = 22
  }
  "80" = {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = [80, 443]
    to_port     = 80
  }
  "443" = {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
  }
}