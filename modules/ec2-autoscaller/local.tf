locals {
  alb = {
    desired_capacity = 2
    max_size = 6
    min_size = 2
    health_check_type = "EC2"
    health_check_grace_period = 300
    force_delete = true
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = 2
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = 120
    statistic = "Average"
    threshold = 70
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
}
}