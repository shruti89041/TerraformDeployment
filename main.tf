# Step 1: IAM Role Section
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

  # Attach inline policies or managed policies here as needed
  # ...
}

resource "aws_kinesis_stream" "example_stream" {
  name        = "example-stream"
  shard_count = 1
  retention_period = 48

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}


resource "aws_s3_bucket_object" "nexus_to_s3_upload" {
  bucket = "your-s3-bucket-name"  # S3 bucket name
  key    = "your/object/key-prefix/ics.zip"  # Object key in S3

  source = "https://your-nexus-url/ics.zip"  # Nexus file URL

  # ACL can be configured according to your requirements
  # acl = "private"
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

  kinesis_stream = aws_kinesis_stream.example_stream
}

# Rest of your resources and configurations go here
resource "aws_lambda_event_source_mapping" "kinesis_trigger" {
  event_source_arn  = aws_kinesis_stream.example_stream.arn
  function_name     = module.lambda_module.lambda_function_name
  enabled           = true
  batch_size        = 100
  starting_position = "LATEST"
}
