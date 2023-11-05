provider "aws" {
    region = "us-west-2"
}

module "IAM" {
  source        = "../../../modules/IAM"  # Path to IAM module
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
module "Ec2-Autoscaller" {
  source        = "../../../modules/Ec2-Autoscaller"  # Path to Autoscaller module
}



