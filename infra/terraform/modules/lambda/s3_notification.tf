resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = replace(var.s3_bucket_arn, "arn:aws:s3:::", "")

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda.arn
    events              = var.s3_events
    filter_prefix       = var.s3_filter_prefix
    filter_suffix       = var.s3_filter_suffix
  }

  depends_on = [aws_lambda_permission.allow_execution_from_bucket]
}

resource "aws_lambda_permission" "allow_execution_from_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}
