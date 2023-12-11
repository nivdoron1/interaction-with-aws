import json
import time
import uuid

import pytest
import boto3
import os
from moto import mock_s3
from main import get_s3_object_list

s3 = boto3.client('s3', region_name='us-east-1')

#bucket_name = os.environ['BUCKET_NAME']
#function_name = os.environ['FUNCTION_NAME']

bucket_name = 'niv'
function_name = 'func'
def get_unique_bucket_name():
    existing_buckets_response = s3.list_buckets()
    existing_buckets = [bucket['Name'] for bucket in existing_buckets_response['Buckets']]

    unique_id = str(uuid.uuid4())

    while unique_id in existing_buckets:
        unique_id = str(uuid.uuid4())
    return unique_id


@mock_s3
def test_lambda_with_no_bucket():
    os.environ['BUCKET_NAME'] = get_unique_bucket_name()

    # Call the Lambda function
    response = get_s3_object_list({}, {})
    assert response['statusCode'] == 500
    assert 'An error occurred (404) when calling the HeadBucket operation: Not Found' in response['body']


@mock_s3
def test_lambda_before_and_after_insert():
    # Create a mock bucket and set it in the environment
    s3.create_bucket(Bucket=bucket_name)
    os.environ['BUCKET_NAME'] = bucket_name

    # Invoke Lambda before inserting objects
    response_before = get_s3_object_list({}, {})

    with open("testfile.txt", "w") as file:
        file.write("hello world")
    # Insert a file into the mock S3 bucket
    s3.put_object(Bucket=bucket_name, Key='testfile.txt', Body='test content')

    # Invoke Lambda after inserting objects
    response_after = get_s3_object_list({}, {})
    assert response_before['statusCode'] == 200
    assert response_before['body'] == 'No objects in bucket'
    assert response_after['statusCode'] == 200
    assert 'testfile.txt' in response_after['body']
    os.system("rm testfile.txt")


@mock_s3
def test_add_non_permission_bucket():
    bucket = get_unique_bucket_name()

    s3.create_bucket(Bucket=bucket)

    os.environ['BUCKET_NAME'] = bucket
    os.system(f"aws s3 mb s3://{bucket}")
    os.system(
        f"aws lambda update-function-configuration --function-name {function_name} --environment Variables={{"
        f"BUCKET_NAME={bucket}}}")

    os.system(f"aws lambda invoke --function-name {function_name} --payload '{{}}' output.json")
    with open("output.json", "r") as json_file:
        response = json.load(json_file)
    # Remove the output.json file
    os.system("rm output.json")
    s3.delete_bucket(Bucket=bucket)
    os.environ['BUCKET_NAME'] = bucket_name
    assert response['statusCode'] == 500
    assert "An error occurred (AccessDenied) when calling the ListObjectsV2 operation: Access Denied" in response[
        "body"]
