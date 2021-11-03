terraform {
  # This would be better!
  # backend "s3" {
  #   encrypt = "true"
  # }
}

provider "aws" {
  default_tags {
    tags = var.tags
  }
}
