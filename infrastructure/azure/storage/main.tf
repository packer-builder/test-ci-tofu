# Azure Storage Account Module
# Creates a storage account with blob containers, encryption, and access controls

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Storage Account
resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  account_kind             = var.account_kind
  access_tier              = var.access_tier

  min_tls_version                 = var.min_tls_version
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = var.allow_public_access

  dynamic "blob_properties" {
    for_each = var.enable_versioning || length(var.cors_rules) > 0 || var.soft_delete_retention_days > 0 ? [1] : []
    content {
      versioning_enabled = var.enable_versioning

      dynamic "delete_retention_policy" {
        for_each = var.soft_delete_retention_days > 0 ? [1] : []
        content {
          days = var.soft_delete_retention_days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = var.container_soft_delete_retention_days > 0 ? [1] : []
        content {
          days = var.container_soft_delete_retention_days
        }
      }

      dynamic "cors_rule" {
        for_each = var.cors_rules
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }
    }
  }

  dynamic "network_rules" {
    for_each = var.network_rules != null ? [var.network_rules] : []
    content {
      default_action             = network_rules.value.default_action
      bypass                     = network_rules.value.bypass
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids
    }
  }

  tags = var.tags
}

# Blob Containers
resource "azurerm_storage_container" "containers" {
  for_each = { for c in var.containers : c.name => c }

  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = each.value.access_type
}

# Lifecycle Management Policy
resource "azurerm_storage_management_policy" "main" {
  count              = length(var.lifecycle_rules) > 0 ? 1 : 0
  storage_account_id = azurerm_storage_account.main.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      name    = rule.value.name
      enabled = rule.value.enabled

      filters {
        prefix_match = rule.value.prefix_match
        blob_types   = rule.value.blob_types
      }

      actions {
        dynamic "base_blob" {
          for_each = rule.value.base_blob_actions != null ? [rule.value.base_blob_actions] : []
          content {
            tier_to_cool_after_days_since_modification_greater_than    = base_blob.value.tier_to_cool_after_days
            tier_to_archive_after_days_since_modification_greater_than = base_blob.value.tier_to_archive_after_days
            delete_after_days_since_modification_greater_than          = base_blob.value.delete_after_days
          }
        }

        dynamic "snapshot" {
          for_each = rule.value.snapshot_actions != null ? [rule.value.snapshot_actions] : []
          content {
            delete_after_days_since_creation_greater_than = snapshot.value.delete_after_days
          }
        }

        dynamic "version" {
          for_each = rule.value.version_actions != null ? [rule.value.version_actions] : []
          content {
            delete_after_days_since_creation = version.value.delete_after_days
          }
        }
      }
    }
  }
}
