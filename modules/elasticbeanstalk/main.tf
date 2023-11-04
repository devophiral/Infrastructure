provider "aws" {
  region = var.global.aws_region
}

resource "aws_elastic_beanstalk_application" "my_web_app" {
  name        = var.global.application_name
  description = "My Web App"
}

resource "aws_elastic_beanstalk_environment" "my_web_app_env" {
  name                = var.global.environment_name
  application         = aws_elastic_beanstalk_application.my_web_app.name
  solution_stack_name = "64bit Amazon Linux 2 v4.4.5 running Docker"  # Latest Amazon Linux 2 platform
  tags = {
    name = staging
  }
}
