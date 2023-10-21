variable "function_name" {
  type    = string
  description = "The name of the Lambda function."
}

variable "handler" {
  type    = string
  description = "The handler for the Lambda function."
}

variable "runtime" {
  type    = string
  description = "The runtime for the Lambda function."
}

// Define other input variables as needed
