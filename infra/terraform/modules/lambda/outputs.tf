output "aws_iam_role_id" {
  value       = aws_iam_role.lambda_iam_role.id
  description = "The IAM role id"
}
