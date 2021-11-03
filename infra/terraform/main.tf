resource "random_id" "bucket_key" {
  byte_length = 8
}

module "kms_key" {
  source                  = "./modules/kms"
  kms_name                = "${local.application_prefix}-kms-key"
  kms_description         = "KMS key for ${local.application_prefix}"
  deletion_window_in_days = 7
  role_arns = [
    aws_iam_role.bucket_reader.arn,
    aws_iam_role.bucket_writer.arn
  ]
}

module "source_bucket" {
  source             = "./modules/s3"
  bucket_name        = local.source_bucket_name
  kms_key_arn        = module.kms_key.aws_kms_key_arn
  bucket_key_enabled = true
  force_destroy      = true
  versioning_enabled = false
  lifecycle_rule = [
    {
      id     = "expire-after-7-days"
      prefix = "/"

      expiration = {
        days = 7
      }
    }
  ]

}

module "destination_bucket" {
  source             = "./modules/s3"
  bucket_name        = local.destination_bucket_name
  kms_key_arn        = module.kms_key.aws_kms_key_arn
  bucket_key_enabled = true
  force_destroy      = true
  lifecycle_rule = [
    {
      id     = "delete-non-current"
      prefix = "/"

      noncurrent_version_expiration = {
        days = 7
      }
    }
  ]
}

module "s3_event_lambda" {
  source = "./modules/lambda"

  name               = "${local.application_prefix}-s3-event-lambda"
  description        = "lambda triggered by an s3 event"
  zip_file_path      = "/zips/lambda.zip"
  handler            = "handler.handler"
  runtime            = "python3.8"
  memory_size        = 128
  timeout            = 60
  log_retention_days = 1
  environment_variables = {
    "DESTINATION_BUCKET" = module.destination_bucket.bucket_name
    "KMS_KEY_ID"         = module.kms_key.aws_kms_key_id
  }

  s3_bucket_arn    = module.source_bucket.bucket_arn
  s3_events        = ["s3:ObjectCreated:*"]
  s3_filter_suffix = ".jpg"
}

data "aws_iam_policy_document" "lambda_role_policy_doc" {
  statement {
    sid = "ReadFromSourceBucket"

    actions = [
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      module.source_bucket.bucket_arn,
      "${module.source_bucket.bucket_arn}/*"
    ]
  }

  statement {
    sid = "WriteToDestBucket"

    actions = [
      "s3:Put*",
    ]

    resources = [
      module.destination_bucket.bucket_arn,
      "${module.destination_bucket.bucket_arn}/*"
    ]
  }

  statement {
    sid = "kms"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = [
      module.kms_key.aws_kms_key_arn,
    ]
  }
}

resource "aws_iam_role_policy" "lambda_s3" {
  name   = "lambda-s3-read-write"
  policy = data.aws_iam_policy_document.lambda_role_policy_doc.json
  role   = module.s3_event_lambda.aws_iam_role_id
}
