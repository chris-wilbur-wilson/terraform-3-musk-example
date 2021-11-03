variable "application" {
  type        = string
  description = "The application name"
}

variable "environment" {
  type        = string
  description = "The environment the resource is part of"
}

variable "tags" {
  description = "Tags to add to each resource"
  type        = map(string)
}

variable "assume_role_name" {
  type        = string
  description = "Role name that will be given permissions to assume bucket reader and writer roles"
}

variable "bucket_key_enabled" {
  description = "Enable the use of [S3 Bucket Keys](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-key.html) for SSE-KMS. This saves costs by reducing the number of requests to KMS for Customer Managed Keys (CMKs)."
  type        = bool
  default     = false
}
