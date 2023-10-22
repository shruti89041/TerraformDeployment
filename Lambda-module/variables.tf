variable "function_name" {
  type        = string
  description = "The name of the Lambda function."
}

variable "handler" {
  type        = string
  description = "The handler for the Lambda function."
}

variable "runtime" {
  type        = string
  description = "The runtime for the Lambda function."
}

variable "memory_size" {
  type        = number
  description = "The amount of memory that the Lambda function has."
}

variable "timeout" {
  type        = number
  description = "The function execution timeout in seconds."
}

variable "role" {
  type        = string
  description = "The ARN of the IAM role to be assumed by the Lambda function."
}

variable "layers" {
  type        = list(string)
  description = "A list of Lambda Layer Version ARNs."
}

variable "environment" {
  type        = map(string)
  description = "Environment variables for the Lambda function."
}

variable "stream_name" {
  type        = string
  description = "The name of the Kinesis stream."
}

variable "shard_count" {
  type        = number
  description = "The number of shards for the Kinesis stream."
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket."
}

variable "object_key" {
  type        = string
  description = "The object key in the S3 bucket."
}

variable "source_url" {
  type        = string
  description = "The URL of the source file."
}
