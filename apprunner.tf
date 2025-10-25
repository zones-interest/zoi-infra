# App Runner resources - COMMENTED OUT FOR FARGATE DEPLOYMENT
/*
# IAM role for App Runner
resource "aws_iam_role" "apprunner_build_role" {
  name = "zoi-apprunner-build-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apprunner_build_role" {
  role       = aws_iam_role.apprunner_build_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_iam_role" "apprunner_access_role" {
  name = "zoi-apprunner-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apprunner_access_role" {
  role       = aws_iam_role.apprunner_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_iam_role_policy" "apprunner_ecr_policy" {
  name = "zoi-apprunner-ecr-policy"
  role = aws_iam_role.apprunner_access_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}

# IAM role for App Runner instance
resource "aws_iam_role" "apprunner_instance_role" {
  name = "zoi-apprunner-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for CloudWatch logging
resource "aws_iam_role_policy" "apprunner_cloudwatch_policy" {
  name = "zoi-apprunner-cloudwatch-policy"
  role = aws_iam_role.apprunner_instance_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# App Runner auto scaling configuration
resource "aws_apprunner_auto_scaling_configuration_version" "zoi" {
  auto_scaling_configuration_name = "zoi-autoscaling"
  max_concurrency                 = 100
  max_size                        = 3
  min_size                        = 1
}

# App Runner service
resource "aws_apprunner_service" "zoi" {
  service_name = "zoi-app"

  source_configuration {
    auto_deployments_enabled = false
    
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_access_role.arn
    }
    
    image_repository {
      image_identifier      = "360691803169.dkr.ecr.eu-west-2.amazonaws.com/zoi-frontend:latest"
      image_configuration {
        port = "3000"
        runtime_environment_variables = {
          NODE_ENV            = "production"
          NEXT_PUBLIC_API_URL = "https://${aws_api_gateway_rest_api.api.id}.execute-api.eu-west-2.amazonaws.com/dev"
          NEXTAUTH_SECRET     = var.nextauth_secret
          NEXTAUTH_URL        = "http://localhost:3000"
        }
      }
      image_repository_type = "ECR"
    }
  }

  instance_configuration {
    cpu               = "1 vCPU"
    memory            = "2 GB"
    instance_role_arn = aws_iam_role.apprunner_instance_role.arn
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.zoi.arn

  health_check_configuration {
    healthy_threshold   = 1
    interval            = 10
    path                = "/api/health"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 5
  }

  tags = {
    Name = "zoi-frontend"
  }
}

# CloudWatch Log Group for App Runner
resource "aws_cloudwatch_log_group" "apprunner_logs" {
  name              = "/aws/apprunner/zoi-app/application"
  retention_in_days = 7

  tags = {
    Name = "zoi-apprunner-logs"
  }
}
*/



