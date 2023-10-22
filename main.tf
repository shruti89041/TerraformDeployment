module "iam_role" {
  source = "./modules/iam-role"  # Use the path to your IAM role module

  # Pass variables needed by the IAM role module
  role_name = "lambda-exec-role"
  # Other input variables if needed
}

module "kinesis_stream" {
  source = "./modules/kinesis-stream-module"  # Use the correct path to your Kinesis module

  stream_name = "example-stream"
  shard_count = 1
}

output "kinesis_stream_arn" {
  value = module.kinesis_stream.kinesis_stream.arn
}

module "s3_bucket_object" {
  source = "./modules/s3-bucket-object-module"  # Use the correct path to your S3 bucket object module

  bucket_name = "your-s3-bucket-name"
  object_key  = "your/object/key-prefix/ics.zip"
  source_url  = "https://your-nexus-url/ics.zip"
}


# Your existing resources (IAM role, Kinesis stream, and S3 bucket) go here

# AWS Lambda module definition
module "lambda_module" {
  source = " "
  function_name = "client-provided-function-name"
  handler = "com.example.MyLambdaFunction::handleRequest"
  runtime = "java17"
  memory_size = 512
  timeout = 900
  role = aws_iam_role.lambda_exec_role.arn
  layers = [
    "arn:aws:lambda:us-east-1:123456789012:layer:em-thirdparty-layer:12",
    "arn:aws:lambda:us-east-1:123456789012:layer:em-services-common-layer:22",
  ]

  environment = {
    ENABLE_ENHANCED_MONITORING = "false"
    ENABLE_CODE_PROFILING = "false"
  }

  maximum_event_age_in_seconds = 21600
  destination_config = {
    onFailure = "DestinationArn"
  }

  s3_bucket_name = "your-s3-bucket-name"
  s3_object_key = "your/object/key-prefix/ics.zip"
  nexus_file_url = "https://your-nexus-url/ics.zip"

  kinesis_stream = module.kinesis_stream_arn
}

module "lambda_event_source_mapping" {
  source = "./modules/lambda-event-source-module"  # Use the correct path to your Lambda event module

  event_source_arn  = module.kinesis_stream.kinesis_stream.arn
  function_name     = module.lambda_module.function_name
  batch_size        = 100
  starting_position = "LATEST"
}
