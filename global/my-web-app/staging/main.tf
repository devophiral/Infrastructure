module "iam" {
  source        = "../../../modules/iam"  # Path to IAM module
  global = var.global
}

module "vpc" {  
  source = "../../../modules/vpc"  # Path to VPC module
  global = var.global
}

module "elasticbeanstalk" {
  source    = "../../../modules/elasticbeanstalk"  # Path to Elastic Beanstalk module
  global = var.global

  depends_on = [ module.iam ]
}

module "alb" {
  
  source        = "../../../modules/alb"  # Path to ALB module
  global = var.global

  depends_on = [ module.vpc ]
}

module "ec2-autoscaller" {
  source        = "../../../modules/ec2-autoscaller"  # Path to Autoscaller module
  global = var.global

  input = {
      image_id = "ami-02643bbd3f82ce3b5"
      instance_type = "t2.micro"
    }

  depends_on = [ module.vpc, module.alb ]  
}




