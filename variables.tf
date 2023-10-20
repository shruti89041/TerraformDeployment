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

variable "nexus_url" {
  description = "The URL of the file in Nexus."
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "s3_object_prefix" {
  description = "The object key prefix in the S3 bucket."
  type        = string
}

variable "local_download_path" {
  description = "Local path to save the downloaded file."
  type        = string
}
