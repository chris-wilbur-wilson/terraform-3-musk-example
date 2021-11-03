variable "kms_name" {
  type        = string
  description = "Name of the kms key"
}

variable "deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days"
  type        = number
  default     = 30
}

variable "kms_description" {
  type        = string
  description = "The description of the kms key"
}

variable "role_arns" {
  description = "List of specific role arns to provide access to resultant key"
  type        = list(string)
  default     = []
}
