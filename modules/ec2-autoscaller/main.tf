provider "aws" {
  region = var.global.region
}


# Auto Scaling Configuration

resource "aws_autoscaling_group" "demo" {
  desired_capacity     = 2
  max_size             = 6
  min_size             = 2

  launch_configuration = aws_launch_configuration.demo.id
  vpc_zone_identifier  = [aws_subnet.public.id]  #Link this with public subnet ID

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
  }
}

resource "aws_launch_configuration" "demo" {
  name            = "${var.global.country}-${var.global.organization}-${var.global.environment}-EC2-001"
  image_id        = var.input.image_id  # EC2-Amazon linux2 AMI ID
  instance_type   = var.input.instance_type    # Ec2 instance type
  security_groups = [aws_security_group.demo.id]  # security group ID
  key_name        = var.global.keypair
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
