import json
import boto3
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('cloud-resume-challenge')
def lambda_handler(event, context):
    # TODO implement
    response = table.get_item(Key={
        'id': '1'
    })
    
    views = response['Item']['views']
    view = views + 1
    response = table.put_item(Item={
        'id':'1',
        'views': view
    })
    return view