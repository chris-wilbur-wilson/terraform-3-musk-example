locals {
  root_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  writers_arns = length(var.writers_list) == 0 ? [local.root_arn] : var.writers_list
  readers_arns = length(var.readers_list) == 0 ? [local.root_arn] : var.readers_list

  private_statements = flatten([
    jsondecode(data.template_file.force_https.rendered),
    jsondecode(data.template_file.allow_readers.rendered),
    jsondecode(data.template_file.allow_writers.rendered),
    jsondecode(data.template_file.force_kms.rendered)
  ])

  private_statements_without_force_kms = flatten([
    jsondecode(data.template_file.force_https.rendered),
    jsondecode(data.template_file.allow_readers.rendered),
    jsondecode(data.template_file.allow_writers.rendered)
  ])
}

data "template_file" "bucket_policy" {
  template = file("${path.module}/policy-files/bucket-policy.json")

  vars = {
    STATEMENTS = var.force_kms ? jsonencode(local.private_statements) : jsonencode(local.private_statements_without_force_kms)
  }
}

data "template_file" "force_https" {
  template = file("${path.module}/policy-files/force-https.json")

  vars = {
    BUCKET_NAME = var.bucket_name
  }
}

data "template_file" "force_kms" {
  template = file("${path.module}/policy-files/force-kms.json")

  vars = {
    BUCKET_NAME = var.bucket_name
  }
}

data "template_file" "allow_readers" {
  template = file("${path.module}/policy-files/allow.json")

  vars = {
    BUCKET_NAME = var.bucket_name
    ACTIONS     = jsonencode(["s3:GetObject", "s3:ListBucket"])
    ARNS = (length(local.readers_arns) == 1
      ? jsonencode(element(local.readers_arns, 0))
    : jsonencode(local.readers_arns))
  }
}

data "template_file" "allow_writers" {
  template = file("${path.module}/policy-files/allow.json")

  vars = {
    BUCKET_NAME = var.bucket_name
    ACTIONS     = jsonencode("s3:PutObject")
    ARNS = (length(local.writers_arns) == 1
      ? jsonencode(element(local.writers_arns, 0))
    : jsonencode(local.writers_arns))
  }
}
