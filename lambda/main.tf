#Where all of our main code will be.

#Create a Lambda function that updates the count stored in a DynamoDB database
resource "aws_lambda_function" "lambda_counter" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_counter"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.test"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.12"

}

#Create an IAM policy for the lambda function
#The policy below allows the lambda function to request temporary security credentials
#to assume the permissions of the role,effectively granting the Lambda service the ability
#to act on behalf of the role within the AWS environment
resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17"
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
  }
  EOF
}

#Import IAM attachment policy for full DynamoDB access
resource "aws_iam_policy" "dynamodb_full_access" {
  name        = "dynamodb_full_access_policy"
  description = "Give lambda_counter function full access to DynamoDB"

}
#Import the IAM attachment policy that's in an external JSON file
import {
  to = aws_iam_role_policy.dynamodb_full_access
  id = "aws_iam_role:iam_for_lambda"
}

#Note that lambda functions are uploaded to terraform via zip file
#The code bellow takes the lambda function and zip the file
data "archive_file" "zip" {
    type = "zip"
    source_dir = "${path.module}/lambda_counter/"
    output_path = "${path.module}/packed_lambda_counter.zip"
}

#Enable Function URL so that you can access your 
#lambda function through your website
resource "aws_lambda_function_url" "test_latest" {
  function_name      = aws_lambda_function.test.function_name
  authorization_type = "NONE"
}

resource "aws_lambda_function_url" "test_live" {
  function_name      = aws_lambda_function.test.function_name
  qualifier          = "my_alias"
  authorization_type = "AWS_IAM"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

