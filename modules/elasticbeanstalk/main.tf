provider "aws" {
  region = var.global.aws_region
  assume_role {
    role_arn = aws_iam_role.elasticbeanstalk_role.arn
  }
}

# Configure Elastic Beanstalk application and environment
resource "aws_elastic_beanstalk_application" "my_web_app" {
  name        = "my-web-app"
  description = "My Web App-Staging"
}

resource "aws_elastic_beanstalk_environment" "my_web_app_env" {
  name                = "my-web-app-env"
  application         = aws_elastic_beanstalk_application.my_web_app.name
  solution_stack_name = "64bit Amazon Linux 2 v4.4.5 running Docker"  # Latest Amazon Linux 2 platform

}

output "elastic_beanstalk_url" {
  value = aws_elastic_beanstalk_environment.my_web_app_env.endpoint_url
}
