provider "aws" {
    region = "ap-south-1"
}

module "vpc" {
  source = "../../../modules/vpc"  # Path to VPC module
}

module "alb" {
  source        = "../../../modules/alb"  # Path to ALB module
}

module "elasticbeanstalk" {
  source              = "../../../modules/elasticbeanstalk"  # Path to Elastic Beanstalk module
}
