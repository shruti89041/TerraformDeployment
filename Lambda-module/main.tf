resource "aws_lambda_function" "example_lambda" {
  function_name = var.function_name
  handler      = var.handler
  runtime      = var.runtime
  memory_size  = var.memory_size
  timeout      = var.timeout

  role    = var.role
  layers  = var.layers

  environment {
    variables = var.environment
  }

  # ... Additional AWS Lambda configuration ...

  // Output the Lambda function's ARN
  output "lambda_function_arn" {
    value = aws_lambda_function.example_lambda.arn
  }
}

