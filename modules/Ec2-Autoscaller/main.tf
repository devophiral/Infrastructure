provider "aws" {
  region = var.region
}


# Auto Scaling Configuration

resource "aws_autoscaling_group" "demo" {
  desired_capacity     = 2
  max_size             = 6
  min_size             = 2

  launch_configuration = aws_launch_configuration.demo.id
  vpc_zone_identifier  = [aws_subnet.public.id]  #Link this with public subnet ID

  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete             = true

  tag {
    key                 = "Name"
    value               = "demo-asg"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [availability_zones]
  }
}

resource "aws_launch_configuration" "demo" {
  name            = "demo-config"
  image_id        = "ami-12345678"  # EC2-Amazon linux2 AMI ID
  instance_type   = "t2.micro"     # Ec2 instance type
  security_groups = [aws_security_group.demo.id]  # security group ID
  key_name        = var.global.keypair
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Alarm when CPU exceeds 70%"
  alarm_actions       = [aws_autoscaling_policy.scale_up_policy.arn]

    dimensions {
        AutoScalingGroupName = aws_autoscaling_group.demo.name
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "low-cpu-utilization"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "Alarm when CPU falls below 30%"
  alarm_actions       = [aws_autoscaling_policy.scale_down_policy.arn]

  dimensions {
    AutoScalingGroupName = aws_autoscaling_group.demo.name
  }
}

resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.demo.name
}

resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.demo.name
}
