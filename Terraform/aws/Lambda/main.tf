provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "my-s3-terraform-avl"
}

resource "aws_s3_object" "lambda_function" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "lambda_function.zip"
  source = "./upload/lambda_function.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_dynamodb_trigger_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_ec2_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name         = "LambdaTriggerTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "StopEC2"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  s3_bucket     = aws_s3_bucket.lambda_bucket.bucket
  s3_key        = "lambda_function.zip"

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.dynamodb_table.name
    }
  }

  lifecycle {
    ignore_changes = [function_name]
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic_execution,
    aws_iam_role_policy_attachment.lambda_dynamodb_access,
    aws_iam_role_policy_attachment.lambda_ec2_access
  ]
}

resource "aws_lambda_event_source_mapping" "dynamodb_trigger" {
  event_source_arn  = aws_dynamodb_table.dynamodb_table.stream_arn
  function_name     = aws_lambda_function.lambda_function.arn
  starting_position = "LATEST"

  depends_on = [aws_lambda_function.lambda_function]
}
