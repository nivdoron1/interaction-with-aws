#!/bin/bash

# Replace bucket name in the policy document
sed -i "s/your-bucket-name/${bucket_name}/g" LambdaS3ReadOnlyPolicy.json
sed -i "s/your-bucket-name/${bucket_name}/g" LambdaS3IAMPolicy.json

# Create S3 bucket
aws s3 mb "s3://${bucket_name}"

# create s3 permission for only read and get object access
aws s3api put-bucket-policy --bucket "${bucket_name}" --policy file://LambdaS3ReadOnlyPolicy.json

# Check if the IAM role exists
if aws iam get-role --role-name "${role_name}" >/dev/null 2>&1; then
    echo "An IAM role with the name '${role_name}' already exists."
    # Retrieve the existing role's ARN
    role_arn=$(aws iam get-role --role-name "${role_name}" | jq -r '.Role.Arn')
else
    echo "Creating a new IAM role named '${role_name}'."
    create_role_output=$(aws iam create-role --role-name "${role_name}" --assume-role-policy-document file://trust_policy.json)
    # Retrieve the existing role's ARN
    role_arn=$(echo "$create_role_output" | jq -r '.Role.Arn')
fi

# Add policy to the role
aws iam put-role-policy --role-name "${role_name}" --policy-name "${policy_name}" --policy-document file://LambdaS3IAMPolicy.json

# create new lambda function or taking the current lambda function
if aws lambda get-function --function-name "${function_name}" >/dev/null 2>&1; then
    echo "A Lambda function with the name '${function_name}' already exists."
else
    echo "Creating a new Lambda function named '${function_name}'."
    aws lambda create-function \
      --function-name "${function_name}" \
      --runtime python3.8 \
      --handler main.get_s3_object_list \
      --role "${role_arn}" \
      --zip-file fileb://get_s3_object_list.zip
fi

sleep 2

# Update Lambda function configuration
aws lambda update-function-configuration \
  --function-name "${function_name}" \
  --environment Variables="{BUCKET_NAME=${bucket_name}}"

# return the files to their default mode
sed -i "s/${bucket_name}/your-bucket-name/g" LambdaS3ReadOnlyPolicy.json
sed -i "s/${bucket_name}/your-bucket-name/g" LambdaS3IAMPolicy.json

echo "User and role have been created and attached successfully."
