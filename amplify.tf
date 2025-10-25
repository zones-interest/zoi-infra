resource "aws_amplify_app" "frontend" {
  name         = "zoi-frontend"
  repository   = var.github_repo_url
  access_token = var.github_access_token

  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - cd zoi
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: zoi/.next
        files:
          - '**/*'
  EOT

  environment_variables = {
    NEXT_PUBLIC_API_URL = "https://${aws_api_gateway_rest_api.api.id}.execute-api.eu-west-2.amazonaws.com/dev"
    NEXTAUTH_SECRET     = var.nextauth_secret
    NEXTAUTH_URL        = "https://main.d190rl2a8kesnw.amplifyapp.com"
  }

  custom_rule {
    source = "/<*>"
    status = "200"
    target = "/index.html"
  }
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.frontend.id
  branch_name = "main"

  enable_auto_build = true
}