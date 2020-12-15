import boto3
import json


def lambda_handler(event, context):
    event = json.loads(event['body'])
    try:
        dynamodb = boto3.resource('dynamodb', endpoint_url='https://dynamodb.eu-central-1.amazonaws.com')
        if 'table_name' in event:
            table = dynamodb.Table(event['table_name'])
            if 'item' in event and 'row_id' in event:
                expression = []
                expression_attribute_values = {}
                for field in event['item'].keys():
                    expression.append(f'{field}=:{field}')
                    expression_attribute_values[f':{field}'] = event['item'][field]
                response = table.update_item(
                    Key={
                        'id': event['row_id']
                    },
                    UpdateExpression='set ' + ', '.join(expression),
                    ExpressionAttributeValues=expression_attribute_values,
                    ReturnValues="NONE"
                )
                err = None
            else:
                err = 'You must provide item and row_id'
        else:
            err = 'You must provide table name'
    except:
        err = 'No such table'
    return {
        'statusCode': '400' if err else '200',
        'body': json.dumps({'Error': err}) if err else json.dumps({'Result': 'Success'}),
        'headers': {
            'Content-Type': 'application/json',
        },
    }
