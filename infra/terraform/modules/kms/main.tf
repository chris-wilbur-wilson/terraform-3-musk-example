resource "aws_kms_key" "kms_key" {
  description             = var.kms_description
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key_policy.json
  deletion_window_in_days = var.deletion_window_in_days
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${var.kms_name}"
  target_key_id = aws_kms_key.kms_key.key_id
  depends_on    = [aws_kms_key.kms_key]
}

data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    sid = "Enable current account IAM User Permissions"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = [
      "*"
    ]
  }

  dynamic "statement" {
    for_each = var.role_arns
    content {
      sid = "Enable ${statement.value} IAM Permissions"
      principals {
        type = "AWS"
        identifiers = [
          statement.value
        ]
      }
      effect = "Allow"
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncryptFrom",
        "kms:ReEncryptTo",
        "kms:GenerateDataKey",
        "kms:GenerateDataKeyWithoutPlaintext",
        "kms:DescribeKey",
        "kms:CreateGrant",
        "kms:list*",
        "kms:RevokeGrant"
      ]
      resources = [
        "*"
      ]
    }
  }
}
