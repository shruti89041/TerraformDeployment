
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

# Step 2: AWS Lambda Section
resource "aws_lambda_function" "example_lambda" {
  function_name = "example-lambda"
  handler      = "index.handler"
  runtime      = "nodejs14.x"

  role = aws_iam_role.lambda_exec_role.arn

  # Define Lambda function's deployment package, environment, and other configurations
  # ...

  depends_on = [aws_iam_role.lambda_exec_role]
}

# Step 3: Nexus to S3 Download Module
module "nexus_s3_download" {
  source = "./nexus_s3_download_module"

  aws_region   = "us-east-1"
  nexus_url    = "https://your-nexus-url/your-file.zip"
  local_path   = "/path/to/local/downloaded/file.zip"
}

# Step 4: Nexus to S3 Upload Module
module "nexus_s3_upload" {
  source = "./nexus_s3_upload_module"

  aws_region       = "us-east-1"
  s3_bucket        = "your-s3-bucket-name"
  s3_object_prefix = "your/object/key/prefix/file.zip"
  local_path       = module.nexus_s3_download.local_path
}

# Step 5: AWS Kinesis Section (Optional)
resource "aws_kinesis_stream" "example_stream" {
  name        = "example-stream"
  shard_count = 1

  # Configure the Kinesis stream as needed
  # ...
}

output "s3_bucket_name" {
  value = module.nexus_s3_upload.s3_bucket_name
}

output "s3_object_key" {
  value = module.nexus_s3_upload.s3_object_key
}
