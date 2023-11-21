
data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = ["vpc-tf"]
  }
}

data "aws_subnet" "subnet_1" {
  filter {
    name = "tag:Name"
    values = ["private-subnet1"]
  }
}
data "aws_subnet" "subnet_2" {
  filter {
    name   = "tag:Name"
    values = ["private-subnet2"]  # Assuming you have another subnet for AZ2
  }
}


resource "aws_lb" "demo_load_balancer" {
  name               = "demo-load-balancer"
  
  internal           = false  # Set to true for internal load balancer
  load_balancer_type = "application"
  subnets = [data.aws_subnet.subnet_1.id, data.aws_subnet.subnet_2.id]

  security_groups = [aws_security_group.lb_sg.id]
  enable_deletion_protection = false

  tags = {
    Name = "demo-load-balancer"
  }
}

# Security Group for Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "${var.global.country}-${var.global.organization}-${var.global.environment_name}-lb-security-group"
  vpc_id      = data.aws_vpc.vpc.id
  description = "Security group for the load balancer"

  # Allow inbound traffic for HTTP and HTTPS from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lb-security-group"
  }
}

# Security Group for EC2 instances in the Elastic Beanstalk environment
resource "aws_security_group" "instance_sg" {
  name        = "${var.global.country}-${var.global.organization}-${var.global.environment_name}-Instance-SG"
  description = "Security group for EC2 instances in the Beanstalk environment"
  vpc_id      = data.aws_vpc.vpc.id



  # Allow inbound traffic only from the Load Balancer
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  # Restrict SSH access to a specific IP range (replace X.X.X.X/32 with the desired IP)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Ec2 IP 
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-security-group"
  }
}

output "aws_security_group_lb_sg_output" {
  value = aws_security_group.lb_sg.id
}

output "aws_security_group" {
  value = aws_security_group.instance_sg.id
}
