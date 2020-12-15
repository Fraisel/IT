import boto3
import json


def lambda_handler(event, context):
    body = json.loads(event['body'])
    err = None
    try:
        dynamodb = boto3.resource('dynamodb', endpoint_url='https://dynamodb.eu-central-1.amazonaws.com')
        if 'table_name' in body:
            table = dynamodb.Table(body['table_name'])
            table.delete()
        else:
            err = 'You must provide table_name'
    except:
        err = 'No such table'
    return {
        'statusCode': '400' if err else '200',
        'body': json.dumps({'Error': err}) if err else json.dumps({'Result':'Success'}),
        'headers': {
            'Content-Type': 'application/json',
        },
    }