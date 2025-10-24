# Lambda Layer for shared dependencies
data "archive_file" "lambda_layer" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/shared"
  output_path = "${path.module}/lambda_layer.zip"
}

resource "aws_lambda_layer_version" "shared_layer" {
  filename         = data.archive_file.lambda_layer.output_path
  layer_name       = "socpro-shared-layer"
  compatible_runtimes = ["python3.9"]
  source_code_hash = data.archive_file.lambda_layer.output_base64sha256
}

# Create Project Lambda
data "archive_file" "create_project_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/create_project"
  output_path = "${path.module}/create_project.zip"
}

resource "aws_lambda_function" "create_project" {
  filename         = data.archive_file.create_project_zip.output_path
  function_name    = "socpro-create-project"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  memory_size     = 256
  source_code_hash = data.archive_file.create_project_zip.output_base64sha256
  layers          = [aws_lambda_layer_version.shared_layer.arn]

  environment {
    variables = {
      DYNAMODB_TABLE_PROJECTS = aws_dynamodb_table.projects.name
      JWT_SECRET = var.nextauth_secret
    }
  }
}

# Register User Lambda
data "archive_file" "register_user_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/register_user"
  output_path = "${path.module}/register_user.zip"
}

resource "aws_lambda_function" "register_user" {
  filename         = data.archive_file.register_user_zip.output_path
  function_name    = "socpro-register-user"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  memory_size     = 256
  source_code_hash = data.archive_file.register_user_zip.output_base64sha256
  layers          = [aws_lambda_layer_version.shared_layer.arn]

  environment {
    variables = {
      DYNAMODB_TABLE_USERS = aws_dynamodb_table.users.name
      JWT_SECRET = var.nextauth_secret
    }
  }
}

# Create Profile Lambda
data "archive_file" "create_profile_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/create_profile"
  output_path = "${path.module}/create_profile.zip"
}

resource "aws_lambda_function" "create_profile" {
  filename         = data.archive_file.create_profile_zip.output_path
  function_name    = "socpro-create-profile"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  memory_size     = 256
  source_code_hash = data.archive_file.create_profile_zip.output_base64sha256
  layers          = [aws_lambda_layer_version.shared_layer.arn]

  environment {
    variables = {
      DYNAMODB_TABLE_PROFILES = aws_dynamodb_table.profiles.name
      JWT_SECRET = var.nextauth_secret
    }
  }
}

# Get Profile Lambda
data "archive_file" "get_profile_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/get_profile"
  output_path = "${path.module}/get_profile.zip"
}

resource "aws_lambda_function" "get_profile" {
  filename         = data.archive_file.get_profile_zip.output_path
  function_name    = "socpro-get-profile"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  memory_size     = 256
  source_code_hash = data.archive_file.get_profile_zip.output_base64sha256
  layers          = [aws_lambda_layer_version.shared_layer.arn]

  environment {
    variables = {
      DYNAMODB_TABLE_PROFILES = aws_dynamodb_table.profiles.name
      JWT_SECRET = var.nextauth_secret
    }
  }
}

# Update Profile Lambda
data "archive_file" "update_profile_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/update_profile"
  output_path = "${path.module}/update_profile.zip"
}

resource "aws_lambda_function" "update_profile" {
  filename         = data.archive_file.update_profile_zip.output_path
  function_name    = "socpro-update-profile"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  memory_size     = 256
  source_code_hash = data.archive_file.update_profile_zip.output_base64sha256
  layers          = [aws_lambda_layer_version.shared_layer.arn]

  environment {
    variables = {
      DYNAMODB_TABLE_PROFILES = aws_dynamodb_table.profiles.name
      JWT_SECRET = var.nextauth_secret
    }
  }
}

# Create Reservation Lambda
data "archive_file" "create_reservation_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/create_reservation"
  output_path = "${path.module}/create_reservation.zip"
}

resource "aws_lambda_function" "create_reservation" {
  filename         = data.archive_file.create_reservation_zip.output_path
  function_name    = "socpro-create-reservation"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  memory_size     = 256
  source_code_hash = data.archive_file.create_reservation_zip.output_base64sha256
  layers          = [aws_lambda_layer_version.shared_layer.arn]

  environment {
    variables = {
      DYNAMODB_TABLE_RESERVATIONS = aws_dynamodb_table.reservations.name
      JWT_SECRET = var.nextauth_secret
    }
  }
}

# Get Reservations Lambda
data "archive_file" "get_reservations_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/get_reservations"
  output_path = "${path.module}/get_reservations.zip"
}

resource "aws_lambda_function" "get_reservations" {
  filename         = data.archive_file.get_reservations_zip.output_path
  function_name    = "socpro-get-reservations"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  memory_size     = 256
  source_code_hash = data.archive_file.get_reservations_zip.output_base64sha256
  layers          = [aws_lambda_layer_version.shared_layer.arn]

  environment {
    variables = {
      DYNAMODB_TABLE_RESERVATIONS = aws_dynamodb_table.reservations.name
      JWT_SECRET = var.nextauth_secret
    }
  }
}

# Update Reservation Lambda
data "archive_file" "update_reservation_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/update_reservation"
  output_path = "${path.module}/update_reservation.zip"
}

resource "aws_lambda_function" "update_reservation" {
  filename         = data.archive_file.update_reservation_zip.output_path
  function_name    = "socpro-update-reservation"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  memory_size     = 256
  source_code_hash = data.archive_file.update_reservation_zip.output_base64sha256
  layers          = [aws_lambda_layer_version.shared_layer.arn]

  environment {
    variables = {
      DYNAMODB_TABLE_RESERVATIONS = aws_dynamodb_table.reservations.name
      JWT_SECRET = var.nextauth_secret
    }
  }
}

# Delete Reservation Lambda
data "archive_file" "delete_reservation_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/delete_reservation"
  output_path = "${path.module}/delete_reservation.zip"
}

resource "aws_lambda_function" "delete_reservation" {
  filename         = data.archive_file.delete_reservation_zip.output_path
  function_name    = "socpro-delete-reservation"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  memory_size     = 256
  source_code_hash = data.archive_file.delete_reservation_zip.output_base64sha256
  layers          = [aws_lambda_layer_version.shared_layer.arn]

  environment {
    variables = {
      DYNAMODB_TABLE_RESERVATIONS = aws_dynamodb_table.reservations.name
      JWT_SECRET = var.nextauth_secret
    }
  }
}

# Create Service Lambda
data "archive_file" "create_service_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/create_service"
  output_path = "${path.module}/create_service.zip"
}

resource "aws_lambda_function" "create_service" {
  filename         = data.archive_file.create_service_zip.output_path
  function_name    = "socpro-create-service"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  memory_size     = 256
  source_code_hash = data.archive_file.create_service_zip.output_base64sha256
  layers          = [aws_lambda_layer_version.shared_layer.arn]

  environment {
    variables = {
      DYNAMODB_TABLE_SERVICES = aws_dynamodb_table.services.name
      JWT_SECRET = var.nextauth_secret
    }
  }
}

# Get Services Lambda
data "archive_file" "get_services_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/get_services"
  output_path = "${path.module}/get_services.zip"
}

resource "aws_lambda_function" "get_services" {
  filename         = data.archive_file.get_services_zip.output_path
  function_name    = "socpro-get-services"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  memory_size     = 256
  source_code_hash = data.archive_file.get_services_zip.output_base64sha256
  layers          = [aws_lambda_layer_version.shared_layer.arn]

  environment {
    variables = {
      DYNAMODB_TABLE_SERVICES = aws_dynamodb_table.services.name
      JWT_SECRET = var.nextauth_secret
    }
  }
}

# Delete Service Lambda
data "archive_file" "delete_service_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/delete_service"
  output_path = "${path.module}/delete_service.zip"
}

resource "aws_lambda_function" "delete_service" {
  filename         = data.archive_file.delete_service_zip.output_path
  function_name    = "socpro-delete-service"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  memory_size     = 256
  source_code_hash = data.archive_file.delete_service_zip.output_base64sha256
  layers          = [aws_lambda_layer_version.shared_layer.arn]

  environment {
    variables = {
      DYNAMODB_TABLE_SERVICES = aws_dynamodb_table.services.name
      JWT_SECRET = var.nextauth_secret
    }
  }
}

# Upload File Lambda
data "archive_file" "upload_file_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/upload_file"
  output_path = "${path.module}/upload_file.zip"
}

resource "aws_lambda_function" "upload_file" {
  filename         = data.archive_file.upload_file_zip.output_path
  function_name    = "socpro-upload-file"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  memory_size     = 256
  source_code_hash = data.archive_file.upload_file_zip.output_base64sha256
  layers          = [aws_lambda_layer_version.shared_layer.arn]

  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.images.bucket
      JWT_SECRET = var.nextauth_secret
    }
  }
}

# Get Projects Lambda
data "archive_file" "get_projects_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/get_projects"
  output_path = "${path.module}/get_projects.zip"
}

resource "aws_lambda_function" "get_projects" {
  filename         = data.archive_file.get_projects_zip.output_path
  function_name    = "socpro-get-projects"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  memory_size     = 256
  source_code_hash = data.archive_file.get_projects_zip.output_base64sha256
  layers          = [aws_lambda_layer_version.shared_layer.arn]

  environment {
    variables = {
      DYNAMODB_TABLE_PROJECTS = aws_dynamodb_table.projects.name
      JWT_SECRET = var.nextauth_secret
    }
  }
}