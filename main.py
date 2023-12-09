import boto3
import json

s3 = boto3.client('s3')


def lambda_handler(event, context, bucket_name):
    try:
        response = s3.list_objects_v2(Bucket=bucket_name)
        if 'Contents' in response:
            objects = [item['Key'] for item in response['Contents']]
            return {
                'statusCode': 200,
                'body': json.dumps(objects)
            }
        else:
            return {
                'statusCode': 200,
                'body': 'No objects in bucket'
            }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(str(e))
        }