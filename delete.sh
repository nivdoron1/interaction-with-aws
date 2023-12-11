#!/bin/bash

# delete bucket policy
aws s3api delete-bucket-policy --bucket "${bucket_name}"

# delete bucket
aws s3 rb s3://"${bucket_name}"

# delete role policy
aws iam delete-role-policy --role-name "${role_name}" --policy-name "${policy_name}"

# delete IAM role
aws iam delete-role --role-name "${role_name}"

# delete the lambda function
aws lambda delete-function --function-name "${function_name}"
