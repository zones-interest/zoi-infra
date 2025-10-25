#!/bin/bash

# Get the App Runner service URL
SERVICE_URL=$(terraform output -raw apprunner_service_url)

if [ -z "$SERVICE_URL" ]; then
    echo "Error: Could not get App Runner service URL"
    exit 1
fi

echo "Updating NEXTAUTH_URL to: $SERVICE_URL"

# Update the App Runner service with the correct NEXTAUTH_URL
aws apprunner update-service \
    --service-arn $(terraform output -raw apprunner_service_arn) \
    --source-configuration '{
        "AutoDeploymentsEnabled": true,
        "CodeRepository": {
            "RepositoryUrl": "'$(terraform output -raw github_repo_url)'",
            "SourceCodeVersion": {
                "Type": "BRANCH",
                "Value": "main"
            },
            "CodeConfiguration": {
                "ConfigurationSource": "API",
                "CodeConfigurationValues": {
                    "Runtime": "NODEJS_18",
                    "BuildCommand": "cd zoi && npm ci && npm run build",
                    "StartCommand": "cd zoi && npm start",
                    "RuntimeEnvironmentVariables": {
                        "NODE_ENV": "production",
                        "NEXT_PUBLIC_API_URL": "'$(terraform output -raw api_url)'",
                        "NEXTAUTH_SECRET": "'$(terraform output -raw nextauth_secret)'",
                        "NEXTAUTH_URL": "'$SERVICE_URL'"
                    }
                }
            }
        }
    }' \
    --region eu-west-2

echo "NEXTAUTH_URL updated successfully"