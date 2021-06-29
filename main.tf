module "myapp_vpc" {
  source = "./modules/networking"
  vpc_config = {
    cidr_block       = "172.20.0.0/16"
    instance_tenancy = "default"
    tags = {
      "Name" = "ugam-api"
    }
  }
  app_name = "ugam-api"
}


resource "aws_instance" "web" {
  ami           = "ami-0ab4d1e9cf9a1215a"
  instance_type = "t2.micro"
  subnet_id   = module.myapp_vpc.pub_sub_ids[0]

  tags = {
    Name = "HelloWorld"
  }
}