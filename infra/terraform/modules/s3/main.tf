resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  acl           = var.acl
  policy        = data.template_file.bucket_policy.rendered
  force_destroy = var.force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_key_arn
        sse_algorithm     = "aws:kms"
      }
      bucket_key_enabled = var.bucket_key_enabled
    }
  }

  dynamic "logging" {
    for_each = var.logging_bucket != "" ? [1] : []
    content {
      target_bucket = var.logging_bucket
      target_prefix = "bucket-logs/${var.bucket_name}/"
    }
  }

  versioning {
    enabled = var.versioning_enabled
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule

    content {
      id                                     = lookup(lifecycle_rule.value, "id", null)
      prefix                                 = lookup(lifecycle_rule.value, "prefix", null)
      tags                                   = lookup(lifecycle_rule.value, "tags", null)
      enabled                                = lookup(lifecycle_rule.value, "enabled", true)
      abort_incomplete_multipart_upload_days = lookup(lifecycle_rule.value, "abort_incomplete_multipart_upload_days", null)

      dynamic "expiration" {
        for_each = try([lifecycle_rule.value.expiration], [])

        content {
          date                         = lookup(expiration.value, "date", null)
          days                         = lookup(expiration.value, "days", null)
          expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", null)
        }
      }

      dynamic "transition" {
        for_each = try(lifecycle_rule.value.transition, [])

        content {
          date          = lookup(transition.value, "date", null)
          days          = lookup(transition.value, "days", null)
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = try([lifecycle_rule.value.noncurrent_version_expiration], [])

        content {
          days = lookup(noncurrent_version_expiration.value, "days", null)
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = try(lifecycle_rule.value.noncurrent_version_transition, [])

        content {
          days          = lookup(noncurrent_version_transition.value, "days", null)
          storage_class = noncurrent_version_transition.value.storage_class
        }
      }
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
