locals {
  application_prefix      = "${var.application}-${var.environment}"
  bucket_prefix           = "${local.application_prefix}-${random_id.bucket_key.hex}"
  logging_bucket_name     = "${local.bucket_prefix}-logging"
  lambda_bucket_name      = "${local.bucket_prefix}-lambda"
  source_bucket_name      = "${local.bucket_prefix}-source"
  destination_bucket_name = "${local.bucket_prefix}-destination"
}
