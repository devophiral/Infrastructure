variable "global" {
  type = object({
    country	= string
    environment_name	= string
    organization	= string
    region	= string
    application_name  = string
    cidr_blocks	= list(string)
    public_cidr_block = list(string)
    private_cidr_block = list(string)
    vpc_cidr = list(string)
    keypair = string
    az1 = string
    az2 = string
    policy_arn = string
})
}
