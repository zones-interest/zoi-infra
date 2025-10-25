# App Runner Deployment Guide

## Overview
This guide covers deploying the Next.js application to AWS App Runner instead of Amplify.

## Prerequisites
- AWS CLI configured
- Terraform installed
- GitHub repository access

## Deployment Steps

### 1. Deploy Infrastructure
```bash
cd /Users/radgemaster/Projects/percy/zoi/zoi-infra
terraform plan
terraform apply
```

### 2. Complete GitHub Connection
After deployment, you'll need to complete the GitHub connection in the AWS Console:
1. Go to AWS App Runner console
2. Find the "zoi-github-connection" 
3. Complete the GitHub authorization

### 3. Update NEXTAUTH_URL (Automatic)
The deployment includes a provisioner that automatically updates the NEXTAUTH_URL with the correct App Runner service URL.

### 4. Manual Update (if needed)
If the automatic update fails, run:
```bash
./update-nextauth-url.sh
```

## Environment Variables
The App Runner service is configured with:
- `NODE_ENV=production`
- `NEXT_PUBLIC_API_URL` (from API Gateway)
- `NEXTAUTH_SECRET` (from terraform.tfvars)
- `NEXTAUTH_URL` (App Runner service URL)

## Configuration Changes Made
1. **apprunner.tf**: Complete App Runner service configuration
2. **outputs.tf**: Added App Runner service URL and ARN outputs
3. **.env.local**: Updated with correct API Gateway URL
4. **update-nextauth-url.sh**: Script for manual NEXTAUTH_URL updates

## Key Features
- Auto-scaling (1-3 instances)
- Health checks on `/` endpoint
- GitHub auto-deployments
- Proper IAM roles and permissions
- CORS already configured for all origins

## Accessing the Application
After deployment, the application will be available at the URL shown in:
```bash
terraform output apprunner_service_url
```