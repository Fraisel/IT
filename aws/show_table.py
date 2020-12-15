import boto3
import json


def lambda_handler(event, context):
    event = json.loads(event['body'])
    try:
        dynamodb = boto3.resource('dynamodb', endpoint_url='https://dynamodb.eu-central-1.amazonaws.com')
        if 'table_name' in event:
            table = dynamodb.Table(event['table_name'])
            response = table.scan()
            items = [item for item in response['Items']]
            for item in items:
                item['id'] = int(item['id'])
            err = None
        else:
            err = 'You must provide table name'
    except:
        err = 'No such table'
    return {
        'statusCode': '400' if err else '200',
        'body': json.dumps({'Error': err}) if err else json.dumps(items),
        'headers': {
            'Content-Type': 'application/json'
        },
    }
