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
