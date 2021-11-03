resource "aws_lambda_function" "lambda" {
  filename                       = var.zip_file_path
  function_name                  = var.name
  description                    = var.description
  role                           = aws_iam_role.lambda_iam_role.arn
  handler                        = var.handler
  source_code_hash               = filebase64sha256(var.zip_file_path)
  runtime                        = var.runtime
  layers                         = var.layers
  memory_size                    = var.memory_size
  timeout                        = var.timeout
  publish                        = true
  reserved_concurrent_executions = var.reserved_concurrent_executions

  vpc_config {
    subnet_ids         = var.vpc_subnet_ids
    security_group_ids = var.security_group_ids
  }

  tracing_config {
    mode = var.xray_tracing_enabled ? "Active" : "PassThrough"
  }

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [1] : []

    content {
      variables = var.environment_variables
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = var.log_retention_days
}
