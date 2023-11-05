variable "global" {
  type = object({
    country	= "IN"
    environment_name	= "staging"
    organization	= "Infopercept"
    region	= "us-west-2"
    application_name  = "demo-app"
    vpc_id	=  my_vpc
    cidr_blocks	= ["0.0.0.0/0"]
    public_cidr_block = ["10.0.1.0/24"]
    private_cidr_block = ["10.0.2.0/24"]
    vpc_cidr = ["10.0.0.0/16"]
    IAM_Role	= 
    keypair = "/home/lenovo/Downloads/test.pem"
    az1 = "us-west-2a"
    az2 = "us-west-2b"
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkFullAccess"
})
}