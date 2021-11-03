output "source_bucket_name" {
  description = "Source Bucket Name"
  value       = module.source_bucket.bucket_name
}

output "destination_bucket_name" {
  description = "Destination Bucket Name"
  value       = module.destination_bucket.bucket_name
}

output "kms_key_id" {
  description = "KMS Key Id"
  value       = module.kms_key.aws_kms_key_id
}

output "bucket_reader_arn" {
  description = "ARN of bucket reader role"
  value       = aws_iam_role.bucket_reader.arn
}

output "bucket_writer_arn" {
  description = "ARN of bucket writer role"
  value       = aws_iam_role.bucket_writer.arn
}
