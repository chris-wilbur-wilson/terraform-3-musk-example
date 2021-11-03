variable "bucket_name" {
  description = "Bucket name to create"
}

variable "versioning_enabled" {
  description = "indicates whehter versioning is enabled"
  default     = true
}

variable "acl" {
  description = "acl for the bucket"
  default     = "private"
}

variable "kms_key_arn" {
  description = "ARN of CMK to use for SSE-KMS encryption"
}

variable "bucket_key_enabled" {
  description = "Enable the use of [S3 Bucket Keys](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-key.html) for SSE-KMS. This saves costs by reducing the number of requests to KMS for Customer Managed Keys (CMKs)."
  type        = bool
  default     = false
}

variable "logging_bucket" {
  description = "Logging bucket name"
  default     = ""
}

variable "lifecycle_rule" {
  description = "lifecycle_rule(s), has the same attributes as `lifecycle_rule` in [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#id)"
  type        = any
  default     = []
}

variable "readers_list" {
  description = "Specify the list of IAM role **ARNs** that should be allowed to read from the Bucket. For _Public_ buckets, the _Cloudfront_ identity is automatically added to the list. If not provided, defaults to allow _Account Level Access_"
  type        = list(string)
  default     = []
}

variable "writers_list" {
  description = "Specify the list of IAM role **ARNs** that should be allowed to write to the Bucket. If not provided, defaults to allow _Account Level Access_"
  type        = list(string)
  default     = []
}
variable "force_kms" {
  description = "Indicates if the KMS headers should be used"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. If not provided, defaults to `false`"
  type        = bool
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Shared/default tags to apply to **ALL** taggable resources"
  default     = {}
}
