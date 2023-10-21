variable "kinesis_stream_name" {
  description = "Name of the Kinesis data stream"
  type        = string
  default     = "example-stream"
}

variable "env_alias" {
  description = "Environment alias"
  type        = string
  default     = "v4"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket where the object will be uploaded."
  type        = string
}

variable "s3_object_key_prefix" {
  description = "The prefix for the object key in the S3 bucket."
  type        = string
}

variable "nexus_url" {
  description = "The URL of the Nexus file to download."
  type        = string
}

variable "function_name" {
  description = "The name of the AWS Lambda function."
  type        = string
}

variable "handler" {
  description = "The Lambda function handler."
  type        = string
}
