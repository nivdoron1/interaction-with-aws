#!/bin/bash

# Create IAM user
# shellcheck disable=SC2154
if [ "$create_user" == true ]; then
  aws iam create-user --user-name "$user_name"
fi

# Create policy
# shellcheck disable=SC2154
aws iam create-policy --policy-name "$policy_name" --policy-document "$policy_document"

# Attach policy to user
aws iam attach-user-policy --policy-arn "arn:aws:iam::aws:policy/$policy_name" --user-name "$user_name"

sed -i 's/your-bucket-name/'"$bucket_name"'/g' "$policy_document"

aws iam create-role --role-name "$role_name" --assume-role-policy-document file://trust-policy.json

aws iam put-role-policy --role-name "$role_name" --policy-name LambdaS3ReadOnlyPolicy --policy-document file://LambdaS3ReadOnlyPolicy.json


echo "User and role have been created and attached successfully."