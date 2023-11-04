provider "aws" {
    region = "ap-south-1"
}

module "elasticbeanstalk" {
    source = "../../../modules/elasticbeanstalk"
}