data "aws_iam_role" "example" {
  name = "ElasticBeanstalkRole"
}

# Configure Elastic Beanstalk application and environment
resource "aws_elastic_beanstalk_application" "my_web_app" {
  name        = "tf-test-name"
  description = "tf-test-desc"

  appversion_lifecycle {
    service_role          = data.aws_iam_role.example.arn
    max_count             = 128
    delete_source_from_s3 = true   
  }
}

resource "aws_elastic_beanstalk_environment" "my_web_app_env" {
  name                = "my-web-app-env"
  application         = aws_elastic_beanstalk_application.my_web_app.name
  solution_stack_name = "64bit Amazon Linux 2 v4.4.5 running Docker"  # Latest Amazon Linux 2 platform
}

output "elastic_beanstalk_url" {
  value = aws_elastic_beanstalk_environment.my_web_app_env.endpoint_url
}
