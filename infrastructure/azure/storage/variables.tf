variable "storage_account_name" {
  description = "The name of the storage account (must be globally unique, 3-24 chars, lowercase letters and numbers only)"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "account_tier" {
  description = "The tier of the storage account (Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "replication_type" {
  description = "The replication type for the storage account (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS)"
  type        = string
  default     = "LRS"
}

variable "account_kind" {
  description = "The kind of storage account (StorageV2, Storage, BlobStorage, BlockBlobStorage, FileStorage)"
  type        = string
  default     = "StorageV2"
}

variable "access_tier" {
  description = "The access tier for BlobStorage and StorageV2 accounts (Hot or Cool)"
  type        = string
  default     = "Hot"
}

variable "min_tls_version" {
  description = "The minimum supported TLS version"
  type        = string
  default     = "TLS1_2"
}

variable "allow_public_access" {
  description = "Allow public access to blobs"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable blob versioning"
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain soft-deleted blobs (0 to disable)"
  type        = number
  default     = 7
}

variable "container_soft_delete_retention_days" {
  description = "Number of days to retain soft-deleted containers (0 to disable)"
  type        = number
  default     = 7
}

variable "containers" {
  description = "List of blob containers to create"
  type = list(object({
    name        = string
    access_type = string
  }))
  default = []
}

variable "cors_rules" {
  description = "List of CORS rules for blob storage"
  type = list(object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))
  default = []
}

variable "network_rules" {
  description = "Network rules for the storage account"
  type = object({
    default_action             = string
    bypass                     = list(string)
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })
  default = null
}

variable "lifecycle_rules" {
  description = "List of lifecycle management rules"
  type = list(object({
    name         = string
    enabled      = bool
    prefix_match = list(string)
    blob_types   = list(string)
    base_blob_actions = optional(object({
      tier_to_cool_after_days    = optional(number)
      tier_to_archive_after_days = optional(number)
      delete_after_days          = optional(number)
    }))
    snapshot_actions = optional(object({
      delete_after_days = number
    }))
    version_actions = optional(object({
      delete_after_days = number
    }))
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
