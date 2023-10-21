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

  # Configure the Kinesis stream as needed
  # ...
}


resource "aws_lambda_function" "example_lambda" {
  function_name = "client-provided-function-name"
  handler      = "client-provided-handler"
  runtime      = "java17"  # Runtime: Java 17
  memory_size  = 512       # Memory: 512 MB
  timeout      = 900       # Timeout: 15 minutes (900 seconds)

  # Layers
  layers = [
    "arn:aws:lambda:us-east-1:123456789012:layer:em-thirdparty-layer:12",
    "arn:aws:lambda:us-east-1:123456789012:layer:em-services-common-layer:22",
  ]

  # Kinesis Trigger
  event_source_token = aws_kinesis_stream.example_stream.arn  # Assuming you have defined the Kinesis Stream

  # Logs and Metrics
  tracing_config {
    mode = "PassThrough"  # Active tracing: Not enabled
  }

  environment {
    variables = {
      ENABLE_ENHANCED_MONITORING = "false"
      ENABLE_CODE_PROFILING     = "false"
    }
  }

  # Asynchronous Invocation
  maximum_event_age_in_seconds = 21600  # Maximum age of event is 6 hours
  destination_config {
    onFailure = "DestinationArn"
  }
}

resource "aws_s3_bucket_object" "nexus_to_s3_upload" {
  bucket = "your-s3-bucket-name"  # S3 bucket name
  key    = "your/object/key-prefix/ics.zip"  # Object key in S3

  source = "https://your-nexus-url/ics.zip"  # Nexus file URL

  # ACL can be configured according to your requirements
  # acl = "private"
}
