variable "global" {
  type = object({
    organization	= string
    region	= string
    application_name  = string
    cidr_block	= string
    public_cidr_block = string
    private_cidr_block = string
    private1_cidr_block = string
    vpc_cidr = string
    keypair = string
    az1 = string
    az2 = string
    policy_arn = string
})
}
