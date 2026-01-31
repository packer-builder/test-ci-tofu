variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "The environment for the bucket (e.g., dev, staging, prod)"
  type        = string
}

variable "force_destroy" {
  description = "Allow destruction of non-empty bucket"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN of KMS key for server-side encryption (uses AES256 if not specified)"
  type        = string
  default     = null
}

variable "block_public_access" {
  description = "Block all public access to the bucket"
  type        = bool
  default     = true
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules for the bucket"
  type = list(object({
    id      = string
    enabled = bool
    prefix  = string
    transitions = list(object({
      days          = number
      storage_class = string
    }))
    expiration_days                    = optional(number)
    noncurrent_version_expiration_days = optional(number)
  }))
  default = []
}

variable "cors_rules" {
  description = "List of CORS rules for the bucket"
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_access_logging" {
  description = "Enable access logging for the bucket"
  type        = bool
  default     = false
}

variable "test_storage_class" {
  description = "Storage class for test objects (standard, intelligent_tiering, glacier)"
  type        = string

  validation {
    condition     = contains(["standard", "intelligent_tiering", "glacier"], var.test_storage_class)
    error_message = "test_storage_class must be 'standard', 'intelligent_tiering', or 'glacier'"
  }
}

variable "test_glacier_days" {
  description = "Days before transitioning to Glacier (required when test_storage_class is 'glacier')"
  type        = number
  default     = null

  validation {
    condition     = var.test_storage_class != "glacier" || var.test_glacier_days != null
    error_message = "test_glacier_days is required when test_storage_class is 'glacier'"
  }
}
