output "bucket_name" {
  description = "Bucket Name"
  value       = aws_s3_bucket.bucket.id
}

output "bucket_arn" {
  description = "Bucket Arn"
  value       = aws_s3_bucket.bucket.arn
}
