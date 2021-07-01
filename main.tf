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
  source     = "./modules/elb-classic"
  subnet_ids = module.myapp_vpc.pub_sub_ids
  vpc_id = module.myapp_vpc.vpc_id
}
# Autoscaling Group

module "auto_scaling" {
  source = "./modules/autoscaling"
  launch_config = {
    image_id      = "ami-0ab4d1e9cf9a1215a"
    instance_type = "t2.micro"
    key_name      = "web-api-key"
    user_data     = file("./scripts/apache.sh")
  }
  vpc_id = module.myapp_vpc.vpc_id
  subnet_ids = module.myapp_vpc.pub_sub_ids
  load_balancers = [module.myapp_alb.lb_name]
}

output "scaling_policy" {
  value = module.auto_scaling.scaling_policy
}