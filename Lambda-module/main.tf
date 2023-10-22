resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role"

  # Define the assume_role_policy and other configurations for the IAM role here.
}

# Rest of your resources (e.g., Lambda function) go here

resource "aws_kinesis_stream" "kinesis_stream" {
  name             = var.stream_name
  shard_count      = var.shard_count
  retention_period = 48

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}

resource "aws_s3_bucket_object" "nexus_to_s3_upload" {
  bucket = var.bucket_name
  key    = var.object_key
  source = var.source_url

  # ACL can be configured according to your requirements
  # acl = "private"
}

resource "aws_lambda_function" "example_lambda" {
  function_name = var.function_name
  handler      = var.handler
  runtime      = var.runtime
  memory_size  = var.memory_size
  timeout      = var.timeout

  role    = aws_iam_role.lambda_exec_role.arn
  layers  = var.layers

  environment {
    variables = var.environment
  }

resource "aws_lambda_event_source_mapping" "kinesis_trigger" {
  event_source_arn  = aws_kinesis_stream.example_stream.arn
  function_name     = aws_lambda_function.example_lambda.function_name
  enabled           = true
  batch_size        = 100
  starting_position = "LATEST"
}

