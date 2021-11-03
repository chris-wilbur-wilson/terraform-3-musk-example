variable "name" {
  type        = string
  description = "Name of the lambda function"
}

variable "description" {
  type        = string
  description = "Description of the lambda function"
}

variable "zip_file_path" {
  type        = string
  description = "The location of the lambda zip file"
}

variable "handler" {
  type        = string
  description = "The function handler e.g. `handler.handler`"
}

variable "runtime" {
  type        = string
  description = "The lambda runtime e.g. `python3.7`"
}

variable "layers" {
  type        = list(string)
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function"
  default     = null
}

variable "memory_size" {
  description = "The memory size of the lambda (in MB)"
  type        = string
  default     = "256"
}

variable "timeout" {
  description = "The timeout of the lambda execution in seconds"
  type        = string
  default     = "600"
}

variable "log_retention_days" {
  description = "The number of days the logs are retained"
  type        = string
  default     = "14"
}

variable "vpc_subnet_ids" {
  type        = list(string)
  description = "The VPC subnet ids for the lambda. This is optional and is not needed if the lambda does not need to access resources in the VPC."
  default     = []
}

variable "security_group_ids" {
  type        = list(string)
  description = "The security group ids for the lambda. This is optional and is not needed if the lambda does not need to access resources in the VPC."
  default     = []
}

variable "reserved_concurrent_executions" {
  description = <<-EOT
  The amount of reserved concurrent executions. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1
  See: https://docs.aws.amazon.com/lambda/latest/dg/configuration-concurrency.html
  EOT
  type        = number
  default     = -1
}

variable "environment_variables" {
  description = "environment variables for the lambda"
  type        = map(string)
  default     = {}
}

variable "assume_role_policy" {
  description = "The assume_role_policy document for the lambda IAM role. If not defined, the IAM role will assume `lambda.amazonaws.com`"
  type        = string
  default     = ""
}

variable "xray_tracing_enabled" {
  description = "Whether X-Ray tracing is enabled (=Active)"
  type        = bool
  default     = false
}

variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket which will trigger the lambda."
  type        = string
}

variable "s3_events" {
  description = "The S3 events that will trigger the lambda. See https://docs.aws.amazon.com/AmazonS3/latest/dev/NotificationHowTo.html#supported-notification-event-types"
  type        = list(string)
  default     = ["s3:ObjectCreated:*"]
}

variable "s3_filter_prefix" {
  description = "Filter objects by prefix, e.g. images/"
  type        = string
  default     = ""
}

variable "s3_filter_suffix" {
  description = "Filter objects by suffix, e.g. .jpg"
  type        = string
  default     = ""
}
