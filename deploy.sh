#!/bin/bash

if [ ! -f terraform.tfvars ]; then
    cp terraform.tfvars.example terraform.tfvars
    echo "Please edit terraform.tfvars with your GitHub repo URL"
    exit 1
fi

terraform init
terraform plan
terraform apply

echo "Infrastructure deployed!"
echo "API URL: $(terraform output -raw api_url)"
echo "Frontend URL: $(terraform output -raw amplify_app_url)"