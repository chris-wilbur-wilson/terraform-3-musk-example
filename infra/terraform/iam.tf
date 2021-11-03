resource "aws_iam_role" "bucket_reader" {
  name = "${local.application_prefix}-bucket-reader-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.assume_role_name}"
        }
      },
    ]
  })
}

resource "aws_iam_role" "bucket_writer" {
  name = "${local.application_prefix}-bucket-writer-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.assume_role_name}"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "source_bucket_read_write_document" {
  statement {
    sid = "ReadFromSourceBucket"

    actions = [
      "s3:List*",
      "s3:Get*",
      "s3:Put*",
    ]

    resources = [
      module.source_bucket.bucket_arn,
      "${module.source_bucket.bucket_arn}/*"
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

resource "aws_iam_role_policy" "source_bucket_read_write_policy" {
  name   = "source-bucket-read-write"
  policy = data.aws_iam_policy_document.source_bucket_read_write_document.json
  role   = aws_iam_role.bucket_writer.id
}

data "aws_iam_policy_document" "dest_bucket_read_document" {
  statement {
    sid = "ReadFromDestinationBucket"

    actions = [
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      module.destination_bucket.bucket_arn,
      "${module.destination_bucket.bucket_arn}/*"
    ]
  }

  statement {
    sid = "kms"

    actions = [
      "kms:Decrypt",
    ]

    resources = [
      module.kms_key.aws_kms_key_arn,
    ]
  }
}

resource "aws_iam_role_policy" "dest_bucket_read_policy" {
  name   = "source-bucket-read-write"
  policy = data.aws_iam_policy_document.dest_bucket_read_document.json
  role   = aws_iam_role.bucket_reader.id
}
