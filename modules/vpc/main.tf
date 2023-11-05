provider "aws" {
  region = var.global.region
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.global.vpc_cidr  # VPC CIDR block
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Create Public Subnets
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.global.public_cidr_block
  availability_zone = var.global.az1 # Update with your desired AZ
  map_public_ip_on_launch = true
}

# Create Private Subnets
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.global.private_cidr_block  # private subnet CIDR block
  availability_zone = var.global.az2  # Update with desired AZ2
}

# Create Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.global.cidr_blocks
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

# Associate Public Subnets with Route Tables
resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}
