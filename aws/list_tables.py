import boto3, json


def lambda_handler(event, context):
    client = boto3.client('dynamodb', region_name="eu-central-1")
    tables = client.list_tables()
    return {
        'statusCode': '200',
        'body': json.dumps(tables['TableNames']),
        'headers': {
            'Content-Type': 'application/json',
        },
    }