# IAM role
resource "aws_iam_role" "lambda_iam_role" {
  name_prefix        = substr("${var.name}-iam-role", 0, 32)
  assume_role_policy = length(var.assume_role_policy) > 0 ? var.assume_role_policy : data.aws_iam_policy_document.lambda_assume_role_policy_doc.json

  tags = { "Name" = "${var.name}-iam-role" }
}

data "aws_iam_policy_document" "lambda_assume_role_policy_doc" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

# Logging policy role attachment
resource "aws_iam_role_policy" "lambda_logging" {
  name   = "${var.name}-logging"
  policy = data.aws_iam_policy_document.lambda_logging_policy_doc.json
  role   = aws_iam_role.lambda_iam_role.name
}

# Logging policy
data "aws_iam_policy_document" "lambda_logging_policy_doc" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }
}
