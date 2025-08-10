import json

def handler(event, context):
    print("request: " + json.dumps(event))
    return {
        "statusCode": 200,
        "headers": { "content-type": "text/plain" },
        "body": "Hello from Lambda!",
        "isBase64Encoded": False
    }
