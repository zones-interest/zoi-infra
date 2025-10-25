output "api_url" {
  description = "API Gateway URL"
  value       = "https://${aws_api_gateway_rest_api.api.id}.execute-api.eu-west-2.amazonaws.com/dev"
}

output "s3_bucket" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.images.bucket
}

output "app_url" {
  description = "Application Load Balancer DNS name"
  value       = "http://${aws_lb.zoi.dns_name}"
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.zoi.name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.zoi.name
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