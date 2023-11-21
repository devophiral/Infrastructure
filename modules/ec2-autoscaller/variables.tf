variable "global" {
  type = object({
    country	= string
    environment_name	= string
    organization	= string
    region	= string
    public_cidr_block = string
    vpc_cidr = string
    # keypair = string
})
}
