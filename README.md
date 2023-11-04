# Elastic Beanstalk Infrastructure with Terraform

This Terraform script sets up an AWS Elastic Beanstalk environment for my-web-app application.

### Prerequisites
- Terraform installed
- AWS CLI configured
- Specific IP range for SSH access

### Instructions
1. Clone this repository.
2. Set up AWS credentials.(IAM user or role)
3. Modify variables in `global_variable.tf` if needed.
4. Run `terraform init`, `terraform plan`, `terraform apply`.
5. `terraform plan -var-file="gloabl/my-web-app/{environment}/global_variables.tfvars"`,
   `terraform apply -var-file="gloabl/my-web-app/{environment}/global_variables.tfvars"`,
   `terrafrom destroy -var-file="gloabl/my-web-app/{environment}/global_variables.tfvars"`
   
6. Access the deployed application using the provided URL in outputs.

### Architecture Overview
The setup includes:
- Elastic Beanstalk Application & Environment
- EC2 Auto Scaling & Load Balancer
- Security Groups for HTTP, HTTPS, and SSH restrictions
- Network across multiple availability zones

### Variables defines in (global/global_variable.tf)
- AWS region
- Elastic Beanstalk details
- Auto Scaling configurations
- IP range for SSH access
  
### Module based structure (modules/<module_name>/main.tf)
- IAM 
- Elasticbeanstalk
- EC2
- Autoscaller
- VPC

For more detailed information, refer to individual modules main.tf files.
