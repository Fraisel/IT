import boto3
import json


def type_for_field(field: str) -> str:
    if field in ['integer', 'real']:
        return 'N'
    return 'S'


def lambda_handler(event, context):
    body = json.loads(event['body'])
    dynamodb = boto3.resource('dynamodb', endpoint_url='https://dynamodb.eu-central-1.amazonaws.com')
    if 'fields' in body and 'table_name' in body:
        table = dynamodb.create_table(
            TableName=body['table_name'],
            KeySchema=[
                {
                    'AttributeName': 'id',
                    'KeyType': 'HASH'  # Partition key
                }
            ],
            AttributeDefinitions=[
                {
                    'AttributeName': 'id',
                    'AttributeType': 'N'
                }
            ],
            ProvisionedThroughput={
                'ReadCapacityUnits': 1,
                'WriteCapacityUnits': 1
            }
        )
        err = None
    else:
        err = 'You must provide table name and fields'
    return {
        'statusCode': '400' if err else '200',
        'body': json.dumps({'Error': err}) if err else json.dumps({'Result': 'Success'}),
        'headers': {
            'Content-Type': 'application/json',
        },
    }
