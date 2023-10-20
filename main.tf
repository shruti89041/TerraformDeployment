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


resource "aws_s3_bucket" "example_bucket" {
  bucket = "your-bucket-name"
  acl    = "public-read-write" # By default, set the ACL to private

  # Additional bucket configurations as needed
}

# Step 2: Define an S3 Bucket Policy
resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.example_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicRead",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
                    "s3:PutObject"
        Resource  = aws_s3_bucket.example_bucket.arn
        Condition = {
          StringEquals = {
            "s3:ExistingObjectTag/allow-public-read" = "true"
          }
        }
      }
    ]
  })
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
  source = "./nexus_s3_download_module" # Replace with the actual module source

  aws_region   = "us-east-1"
  nexus_url    = "https://your-nexus-url/your-file.zip" # URL of the file in Nexus
  local_path   = "/path/to/local/downloaded/file.zip" //s3 folder
}

# Step 4: Nexus to S3 Upload Module
module "nexus_s3_upload" {
  source = "./nexus_s3_upload_module"

  aws_region       = "us-east-1"
  s3_bucket        = "your-s3-bucket-name"  # S3 bucket name
  s3_object_prefix = "s3://my-bucket/my-folder/my-file.txt" # Object key prefix in S3
  local_path       = module.nexus_s3_download.local_path
}

# Step 5: AWS Kinesis Section (Optional)
resource "aws_kinesis_stream" "example_stream" {
  name        = "example-stream"
  shard_count = 1

  # Configure the Kinesis stream as needed
  # ...
}
