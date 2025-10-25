output "api_url" {
  description = "API Gateway URL"
  value       = "https://${aws_api_gateway_rest_api.api.id}.execute-api.eu-west-2.amazonaws.com/dev"
}

output "s3_bucket" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.images.bucket
}

output "apprunner_service_url" {
  description = "App Runner service URL"
  value       = "https://${aws_apprunner_service.zoi.service_url}"
}

output "apprunner_service_arn" {
  description = "App Runner service ARN"
  value       = aws_apprunner_service.zoi.arn
}

output "github_repo_url" {
  description = "GitHub repository URL"
  value       = var.github_repo_url
}

output "nextauth_secret" {
  description = "NextAuth secret"
  value       = var.nextauth_secret
  sensitive   = true
}