variable "global" {
  type = object({
    country	= string
    environment_name	= string
    organization	= string
    region	= string
    application_name  = string
    vpc_id	= string
    cidr_blocks	= list(string)
    server_ip	= string
    server_name	= string
    private_subnet	= list(string)
    public_subnet	= list(string)
    IAM_Role	= string
    keypair = string
})
}
