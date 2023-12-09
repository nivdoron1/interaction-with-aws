# interaction-with-aws
## install requirments
    pip install -r requirments.txt

## Download and Install the AWS CLI using Linux

To download and install the AWS CLI, follow these steps:

```bash
# Download the AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzip the downloaded file
unzip awscliv2.zip

# Install the AWS CLI
sudo ./aws/install
```

After installation, you can verify it by running `aws --version`. This should display the installed version of the AWS CLI.

## Update the AWS CLI

To update your current installation of the AWS CLI, use the following command. Ensure to replace the paths with your existing symlink and installation directory.

```bash
# Update the AWS CLI
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
```

To locate the existing symlink and installation directory, use the following steps:

1. **Locate the Symlink:**

   Use the `which` command to find your symlink. This gives you the path to use with the `--bin-dir` parameter.

   ```bash
   $ which aws
   /usr/local/bin/aws
   ```

2. **Find the Installation Directory:**

   Use the `ls` command to find the directory that your symlink points to. This gives you the path to use with the `--install-dir` parameter.

   ```bash
   $ ls -l /usr/local/bin/aws
   lrwxrwxrwx 1 ec2-user ec2-user 49 Oct 22 09:49 /usr/local/bin/aws -> /usr/local/aws-cli/v2/current/bin/aws
   ```

3. **Confirm the Installation:**

   After updating, confirm the installation with the following command:

   ```bash
   $ aws --version
   aws-cli/2.10.0 Python/3.11.2 Linux/4.14.133-113.105.amzn2.x86_64 botocore/2.4.5
   ```

---

## connect your administrator account
   ```bash
      # enter your  AWS Access Key ID ,AWS Secret Access Key ,Default region name , Default output format
      # you can change your output format in any command by your choice by adding --output <your_format_type>
      aws configure
   ```
## create IAM user and give him the S3 permissions
   ```bash
      # if you are creating IAM user keep it True else change to false
      export create_user= true
   ```
   ```bash
      #write your desired username
      export user_name="<YourUserName>"
   ```
   ```bash
      #write your desired username
      export role_name="S3ReadWritePolicy"
   ```
   ```bash
      #write your desired username
      export bucket_name="<YourBucketName>"
   ```
   ```bash
      #write your desired username
      export policy_document= "LambdaS3ReadOnlyPolicy.json"
   ```
   