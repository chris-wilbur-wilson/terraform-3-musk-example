output "aws_kms_key_arn" {
  value       = aws_kms_key.kms_key.arn
  description = "The KMS key arn"
}

output "aws_kms_key_id" {
  value       = aws_kms_key.kms_key.key_id
  description = "The KMS key id"
}
