import json
import os
import boto3

project_name  = os.getenv('CODEBUILD_NAME', 'VSH_Build_Server')

def invoke_codebuild(key_name, instance_size):
  codebuild = boto3.client('codebuild')
  res = codebuild.start_build(
    projectName=project_name,
    environmentVariablesOverride=[
      {
        'name': 'KEY_NAME',
        'value': key_name
      },
      {
        'name': 'INSTANCE_SIZE',
        'value': instance_size
      },
    ]
  )
  return res

def handler(event, context):
  body = event.get('body',{})
  body_as_json = json.loads(body)
  key_name = body_as_json.get('KEY_NAME', 'HelloWorld')
  instance_size = body_as_json.get('INSTANCE_SIZE', 't2.micro')
  resp = invoke_codebuild(key_name, instance_size)
  return {
    "headers": {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Credentials': True,
    },
    "statusCode": 200,
    "body": json.dumps(resp['ResponseMetadata']['HTTPStatusCode'])
  }

if __name__ == "__main__":
  invoke_codebuild(key_name="cory-test", instance_size="t2.micro")