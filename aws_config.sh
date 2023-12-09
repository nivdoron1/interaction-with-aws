#!/bin/bash

# Create IAM user
# shellcheck disable=SC2154
aws iam create-user --user-name "$user_name"

# Create policy
# shellcheck disable=SC2154
aws iam create-policy --policy-name "$policy_name" --policy-document "$policy_document"

# Attach policy to user
aws iam attach-user-policy --policy-arn "arn:aws:iam::aws:policy/$policy_name" --user-name "$user_name"

echo "User and policy have been created and attached successfully."