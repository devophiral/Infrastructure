provider "aws" {
    region = var.global.region
}

module "iam" {
  source        = "../../../modules/iam"  # Path to IAM module
  global = var.global
}
module "vpc" {
  source = "../../../modules/vpc"  # Path to VPC module
  global = var.global
}

module "elasticbeanstalk" {
  global = var.global
  source    = "../../../modules/elasticbeanstalk"  # Path to Elastic Beanstalk module
}
module "alb" {
  global = var.global
  source        = "../../../modules/alb"  # Path to ALB module
  subnet_id = module.vpc.public_subnet_id.id
}
module "ec2-autoscaller" {
  source        = "../../../modules/ec2-autoscaller"  # Path to Autoscaller module
  global = var.global
  input = {
      image_id = "ami-02643bbd3f82ce3b5"
      instance_type = "t2.micro"
    }
}

output "iam_output" {
  depends_on = [ 
    module.iam
    ]
  value =  module.iam
}

output "vpc_output" {
  depends_on = [ module.vpc ]
  value =  module.vpc
}

output "elasticbeanstalk_output" {
  depends_on = [ module.elasticbeanstalk ]
  value =  module.elasticbeanstalk
}

output "alb_output" {
  depends_on = [ module.alb ]
  value =  module.alb
}

output "ec2-autoscaller_output" {
  depends_on = [ module.ec2-autoscaller ]
  value =  module.ec2-autoscaller
}



