resource "aws_iam_role" "elasticbeanstalk_role" {
  name = "ElasticBeanstalkRole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow",
        Action = "iam:GetRole",
        Resource = "arn:aws:iam::168289737616:role/ElasticBeanstalkRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "elasticbeanstalk_policy_attachment" {
  name       = "ElasticBeanstalkPolicyAttachment"
  roles      = [aws_iam_role.elasticbeanstalk_role.name]
  policy_arn = var.global.policy_arn
}

output "elasticbeanstalk_role" {
  value = aws_iam_role.elasticbeanstalk_role.arn
}