# Manage AWS
## Install Requirements
First, install the necessary dependencies for the AWS CLI and utilities like `jq` and `zip` using the following commands:

```bash
# Install requirements
sudo apt-get update
sudo apt-get install -y jq zip
```

## Download and Install the AWS CLI using Linux
The AWS CLI is a tool to manage AWS services. Install it on a Linux machine with these steps:

```bash
# Download the AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzip the downloaded file
unzip awscliv2.zip

# Install the AWS CLI
sudo ./aws/install
```

After installation, verify it by running `aws --version`.

## Update the AWS CLI
To update your AWS CLI installation, replace the paths with your existing symlink and installation directory:

```bash
# Update the AWS CLI
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
```

Follow these steps to locate the symlink and installation directory:

1. Locate the Symlink: Use `which aws` to find the path.
2. Find the Installation Directory: Use `ls -l /usr/local/bin/aws` to find where the symlink points.
3. Confirm the Installation: Run `aws --version` after updating.

## Connect Your Account
Configure the AWS CLI with your AWS credentials and default settings:

```bash
aws configure
```

## Config and Run
Set environment variables for your AWS resources:

```bash
export role_name="<YourRoleName"
export bucket_name="<YourBucketName>"
export function_name= "<YourFunctionName>"
export policy_name= "<YourPolicyName>"
```
```bash
bash aws_config.sh
```

## Test the Lambda Function
Test the AWS Lambda function by invoking it with predefined parameters:

```bash
BUCKET_NAME=your-bucket-name FUNCTION_NAME=your-function-name pytest test.py
```

## Delete the Configuration and Bucket
Remove the created AWS configurations and S3 bucket:

```bash
bash delete.sh
```

## Python and Bash Scripts
The `get_s3_object_list` Python script defines an AWS Lambda function for listing objects in an S3 bucket. The bash scripts (`aws_config.sh` and `delete.sh`) help in setting up and cleaning up AWS resources.

## Functionality of the Setup
This setup is designed for deploying a Python-based AWS Lambda function to interact with AWS S3. The function, when triggered, lists objects in a specified S3 bucket. This automated, serverless functionality is useful for applications involving data processing or file management in the cloud. The provided scripts facilitate easy configuration, testing, and cleanup of AWS resources.
