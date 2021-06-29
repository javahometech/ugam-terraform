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

module "myapp_alb" {
  source = "./modules/elb-classic"
  subnet_ids = module.myapp_vpc.pub_sub_ids
}