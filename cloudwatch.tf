# CloudWatch Log Groups for Lambda functions
resource "aws_cloudwatch_log_group" "create_project" {
  name              = "/aws/lambda/zoi-create-project"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "get_projects" {
  name              = "/aws/lambda/zoi-get-projects"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "create_profile" {
  name              = "/aws/lambda/zoi-create-profile"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "get_profile" {
  name              = "/aws/lambda/zoi-get-profile"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "update_profile" {
  name              = "/aws/lambda/zoi-update-profile"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "register_user" {
  name              = "/aws/lambda/zoi-register-user"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "login_user" {
  name              = "/aws/lambda/zoi-login-user"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "create_reservation" {
  name              = "/aws/lambda/zoi-create-reservation"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "get_reservations" {
  name              = "/aws/lambda/zoi-get-reservations"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "update_reservation" {
  name              = "/aws/lambda/zoi-update-reservation"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "delete_reservation" {
  name              = "/aws/lambda/zoi-delete-reservation"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "create_service" {
  name              = "/aws/lambda/zoi-create-service"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "get_services" {
  name              = "/aws/lambda/zoi-get-services"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "delete_service" {
  name              = "/aws/lambda/zoi-delete-service"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "upload_file" {
  name              = "/aws/lambda/zoi-upload-file"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "api_gateway" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.api.id}/dev"
  retention_in_days = 14
}