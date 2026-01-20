#!/bin/bash

#!/bin/bash

# Configuration
S3_BUCKET="submission-state-bucket"
S3_KEY="terraform.tfstate"

cleanup() {
  echo "Cleaning up..."
  rm -f "terraform.tfstate"
  rm -f "terraform.tfplan"
}

echo "Initializing Terraform..."
terraform init -backend-config path="./terraform.tfstate" -reconfigure

terraform plan -var-file="../common.tfvars.json" -out="terraform.tfplan"

read -p "Do you want to proceed with applying Terraform changes? (yes/no): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
    echo "Terraform apply aborted by user."

    cleanup

    exit 0
fi

echo "Applying Terraform changes..."
terraform apply -backup="" "terraform.tfplan"

# Upload the updated state back to S3
echo "Uploading Terraform state file to S3..."
aws s3 cp "terraform.tfstate" "s3://$S3_BUCKET/$S3_KEY"

cleanup

if [ $? -eq 0 ]; then
  echo "Terraform state successfully uploaded to S3."
else
  echo "Failed to upload Terraform state to S3."
  exit 1
fi

echo "Terraform execution completed successfully."
