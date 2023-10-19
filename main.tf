

resource "aws_kinesis_stream" "example_stream" {
  name             = "example-stream"
  shard_count      = 1
}

resource "aws_lambda_function" "example_lambda" {
  function_name = "example-lambda"
  handler      = "index.handler"
  runtime      = "nodejs14.x"

  role = aws_iam_role.lambda_exec_role.arn

  environment {
    variables = {
      KINESIS_STREAM_NAME = aws_kinesis_stream.example_stream.name
    }
  }

  depends_on = [aws_kinesis_stream.example_stream]

  filename = "lambda.zip"  # Specify the path to your deployment package (lambda.zip)
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}
