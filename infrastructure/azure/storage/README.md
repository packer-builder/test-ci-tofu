# Module: storage

## Description

Creates an Azure Storage Account with optional blob containers, lifecycle management, and network rules

## Features

- Creates a storage account with configurable tier, replication, and kind
- Supports blob versioning and soft delete retention policies
- Configures CORS rules for blob storage
- Implements lifecycle management policies for blobs, snapshots, and versions
- Allows setting network access rules with IP and subnet restrictions
- Supports creation of multiple blob containers with access control
- Applies custom tags to all resources

## Basic Usage

```hcl
module "storage" {
  source = "git::https://github.com/packer-builder/test-ci-tofu.git//infrastructure/azure/storage?ref=v1.20.0"

  storage_account_name = "your-storage-account-name"
  resource_group_name  = "your-resource-group-name"
  location             = "your-location"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.storage.storage_account_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_storage_account.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.containers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_management_policy.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_management_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The Azure region where resources will be created | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The name of the storage account (must be globally unique, 3-24 chars, lowercase letters and numbers only) | `string` | n/a | yes |
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | The access tier for BlobStorage and StorageV2 accounts (Hot or Cool) | `string` | `"Hot"` | no |
| <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind) | The kind of storage account (StorageV2, Storage, BlobStorage, BlockBlobStorage, FileStorage) | `string` | `"StorageV2"` | no |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | The tier of the storage account (Standard or Premium) | `string` | `"Standard"` | no |
| <a name="input_allow_public_access"></a> [allow\_public\_access](#input\_allow\_public\_access) | Allow public access to blobs | `bool` | `false` | no |
| <a name="input_container_soft_delete_retention_days"></a> [container\_soft\_delete\_retention\_days](#input\_container\_soft\_delete\_retention\_days) | Number of days to retain soft-deleted containers (0 to disable) | `number` | `7` | no |
| <a name="input_containers"></a> [containers](#input\_containers) | List of blob containers to create | <pre>list(object({<br/>    name        = string<br/>    access_type = string<br/>  }))</pre> | `[]` | no |
| <a name="input_cors_rules"></a> [cors\_rules](#input\_cors\_rules) | List of CORS rules for blob storage | <pre>list(object({<br/>    allowed_headers    = list(string)<br/>    allowed_methods    = list(string)<br/>    allowed_origins    = list(string)<br/>    exposed_headers    = list(string)<br/>    max_age_in_seconds = number<br/>  }))</pre> | `[]` | no |
| <a name="input_enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | Enable blob versioning | `bool` | `true` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | List of lifecycle management rules | <pre>list(object({<br/>    name         = string<br/>    enabled      = bool<br/>    prefix_match = list(string)<br/>    blob_types   = list(string)<br/>    base_blob_actions = optional(object({<br/>      tier_to_cool_after_days    = optional(number)<br/>      tier_to_archive_after_days = optional(number)<br/>      delete_after_days          = optional(number)<br/>    }))<br/>    snapshot_actions = optional(object({<br/>      delete_after_days = number<br/>    }))<br/>    version_actions = optional(object({<br/>      delete_after_days = number<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | The minimum supported TLS version | `string` | `"TLS1_2"` | no |
| <a name="input_network_rules"></a> [network\_rules](#input\_network\_rules) | Network rules for the storage account | <pre>object({<br/>    default_action             = string<br/>    bypass                     = list(string)<br/>    ip_rules                   = list(string)<br/>    virtual_network_subnet_ids = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_replication_type"></a> [replication\_type](#input\_replication\_type) | The replication type for the storage account (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS) | `string` | `"LRS"` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | Number of days to retain soft-deleted blobs (0 to disable) | `number` | `7` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_ids"></a> [container\_ids](#output\_container\_ids) | Map of container names to their IDs |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | The primary access key for the storage account |
| <a name="output_primary_blob_endpoint"></a> [primary\_blob\_endpoint](#output\_primary\_blob\_endpoint) | The primary blob endpoint |
| <a name="output_primary_connection_string"></a> [primary\_connection\_string](#output\_primary\_connection\_string) | The primary connection string for the storage account |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | The ID of the storage account |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | The name of the storage account |
<!-- END_TF_DOCS -->
