output "iam_output" {
  value =  module.iam
}

output "vpc_output" {
  value =  module.vpc
}

output "elasticbeanstalk_output" {
  value =  module.elasticbeanstalk
}

output "alb_output" {
  value =  module.alb
}

output "ec2-autoscaller_output" {
  value =  module.ec2-autoscaller
}
