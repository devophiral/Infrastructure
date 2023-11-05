provider "aws" {
    region = var.global.region
}

module "iam" {
  source        = "../../../modules/iam"  # Path to IAM module
}
module "vpc" {
  source = "../../../modules/vpc"  # Path to VPC module
}

module "elasticbeanstalk" {
  source    = "../../../modules/elasticbeanstalk"  # Path to Elastic Beanstalk module
}
module "alb" {
  source        = "../../../modules/alb"  # Path to ALB module
}
module "ec2-autoscaller" {
  source        = "../../../modules/ec2-autoscaller"  # Path to Autoscaller module
}

output "iam_output" {
  depends_on = [ module.IAM ]
  value =  module.IAM
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



