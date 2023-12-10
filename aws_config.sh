#!/bin/bash

# Create IAM user
# shellcheck disable=SC2154
if [ "$create_user" == true ]; then
  aws iam create-user --user-name "$user_name"
fi
sudo apt install jq

# Create policy

zip lambda_function.zip main.py


sed -i 's/your-bucket-name/'"$bucket_name"'/g' "$policy_document"

aws s3 mb s3://"$bucket_name"
sleep 1
create_role_output=$(aws iam create-role --role-name "$role_name" --assume-role-policy-document file://trust_policy.json)
sleep 1
role_arn=$(echo "$create_role_output" | jq -r '.Role.Arn')
sleep 1
aws iam put-role-policy --role-name "$role_name" --policy-name LambdaS3IAMPolicy --policy-document file://LambdaS3IAMPolicy.json
sleep 1
create_policy_output=$(aws iam create-policy --policy-name LambdaS3ReadOnlyPolicy --policy-document file://LambdaS3ReadOnlyPolicy.json)
sleep 1
policy_arn=$(echo "$create_policy_output" | jq -r '.Policy.Arn')
sleep 1
aws iam attach-role-policy --role-name "$role_name" --policy-arn "$policy_arn"
sleep 1
aws lambda create-function \
  --function-name "$function_name" \
  --runtime python3.8 \
  --handler main.lambda_handler \
  --role "$role_arn" \
  --zip-file fileb://lambda_function.zip
sleep 1

# Update Lambda function configuration
aws lambda update-function-configuration \
  --function-name "$function_name" \
  --environment "Variables={BUCKET_NAME=$bucket_name}"
sleep 1

# Invoke Lambda function
aws lambda invoke \
  --function-name "$function_name" \
  --payload '{}' \
  output.txt


echo "User and role have been created and attached successfully."