output "api_url" {
  description = "API Gateway URL"
  value       = "https://${aws_api_gateway_rest_api.api.id}.execute-api.eu-west-2.amazonaws.com/dev"
}

output "amplify_app_url" {
  description = "Amplify app URL"
  value       = "https://main.${aws_amplify_app.frontend.default_domain}"
}

output "s3_bucket" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.images.bucket
}