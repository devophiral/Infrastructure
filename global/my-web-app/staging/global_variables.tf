variable "global" {
  type = object({
    country	= string
    environment	= string
    organization	= string
    region	= string
    vpc_id	= string
    cidr_blocks	= list(string)
    server_ip	= string
    server_name	= string
    private_subnet	= list(string)
    public_subnet	= list(string)
    IAM_Role	= string
})
}
