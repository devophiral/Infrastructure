data "aws_vpc" "vpc" {
  filter {
  name = "tag:Name"
    values = ["vpc-tf"]
  }
}

data "aws_subnet" "subnet_1" {
  filter {
    name = "tag:Name"
    values = ["public-subnet1"]
  }
}

# Create a key
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "private_key"
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "local_file" "local_key" {
  content         = tls_private_key.private_key.private_key_pem
  filename        = "${aws_key_pair.key_pair.key_name}.pem"
  file_permission = "400"
}

# #Define the key pair
# resource "aws_key_pair" "example" {
#   key_name   = "test"  # The name of the key pair
#   public_key = "/home/lenovo/Downloads/test.pem"  # The public key file for the key pair
# }

data "aws_security_group" "instance_sg" {
  name = "${var.global.country}-${var.global.organization}-${var.global.environment_name}-Instance-SG"
}
# Auto Scaling Configuration

resource "aws_launch_configuration" "demo" {
  name     = "terraform-lc-example"
  image_id        = "ami-01ed306a12b7d1c96"  # EC2-Amazon linux2 AMI ID
  instance_type   = "t2.micro"
  security_groups = [data.aws_security_group.instance_sg.id] #sec group from alb module
  key_name        = aws_key_pair.key_pair.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "demo" {
  name = "terraform-asg-example"
  desired_capacity     = 2
  max_size             = 6
  min_size             = 2

  launch_configuration = aws_launch_configuration.demo.id
  # vpc_zone_identifier  = [aws_subnet.public.id]  #Link this with public subnet ID
  vpc_zone_identifier  = [data.aws_subnet.subnet_1.id] #Link this with public subnet ID
  health_check_type         = local.alb.health_check_type
  health_check_grace_period = local.alb.health_check_grace_period
  force_delete             = true

  tag {
    key                 = "Name"
    value               = "demo-asg"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [availability_zones]
    create_before_destroy = true
  }
  depends_on = [ aws_launch_configuration.demo ]
}


resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-utilization"
  comparison_operator = local.alb.comparison_operator

  evaluation_periods  = local.alb.evaluation_periods
  metric_name         = local.alb.metric_name
  namespace           = local.alb.namespace
  period              = local.alb.period
  statistic           = local.alb.statistic
  threshold           = local.alb.threshold
  alarm_description   = "Alarm when CPU exceeds 70%"
  alarm_actions       = [aws_autoscaling_policy.scale_up_policy.arn]

  dimensions = {
      AutoScalingGroupName = aws_autoscaling_group.demo.name
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "low-cpu-utilization"
  comparison_operator = local.alb.comparison_operator
  evaluation_periods  = local.alb.evaluation_periods
  metric_name         = local.alb.metric_name
  namespace           = local.alb.namespace
  period              = local.alb.period
  statistic           = local.alb.statistic
  threshold           = local.alb.threshold 
  alarm_description   = "Alarm when CPU falls below 30%"
  alarm_actions       = [aws_autoscaling_policy.scale_down_policy.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.demo.name
  }
}

resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale-up-policy"
  scaling_adjustment     = local.alb.scaling_adjustment
  adjustment_type        = local.alb.adjustment_type
  cooldown               = local.alb.cooldown
  autoscaling_group_name = aws_autoscaling_group.demo.name
}

resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "scale-down-policy"
  scaling_adjustment     = local.alb.scaling_adjustment
  adjustment_type        = local.alb.adjustment_type
  cooldown               = local.alb.cooldown
  autoscaling_group_name = aws_autoscaling_group.demo.name
}
