# Module: sql

## Description

Creates an Azure SQL Server and Database with security configurations

## Features

- Creates an Azure SQL Server with customizable settings
- Configures an Azure SQL Database with flexible options for size and performance
- Supports Azure AD administrator integration for enhanced security
- Enables configuration of firewall and virtual network rules for access control
- Provides options for short-term and long-term backup retention policies
- Supports server auditing with customizable storage and retention settings
- Allows tagging of all resources for better organization and management

## Basic Usage

```hcl
module "sql" {
  source = "git::https://github.com/packer-builder/test-ci-tofu.git//infrastructure/azure/sql?ref=v1.20.0"

  server_name                  = "your-server-name"
  resource_group_name          = "your-resource-group-name"
  location                     = "your-location"
  administrator_login          = "your-administrator-login"
  administrator_login_password = "your-administrator-login-password"
  database_name                = "your-database-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.sql.server_id
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
| [azurerm_mssql_database.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_firewall_rule.rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule) | resource |
| [azurerm_mssql_server.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_mssql_server_extended_auditing_policy.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_extended_auditing_policy) | resource |
| [azurerm_mssql_virtual_network_rule.vnet_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_virtual_network_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | The administrator login name for the SQL Server | `string` | n/a | yes |
| <a name="input_administrator_login_password"></a> [administrator\_login\_password](#input\_administrator\_login\_password) | The administrator login password | `string` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | The name of the SQL Database | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where resources will be created | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group | `string` | n/a | yes |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | The name of the SQL Server | `string` | n/a | yes |
| <a name="input_auditing_retention_days"></a> [auditing\_retention\_days](#input\_auditing\_retention\_days) | Number of days to retain audit logs | `number` | `90` | no |
| <a name="input_auditing_storage_access_key"></a> [auditing\_storage\_access\_key](#input\_auditing\_storage\_access\_key) | Storage account access key for auditing | `string` | `null` | no |
| <a name="input_auditing_storage_endpoint"></a> [auditing\_storage\_endpoint](#input\_auditing\_storage\_endpoint) | Storage account endpoint for auditing | `string` | `null` | no |
| <a name="input_auto_pause_delay_in_minutes"></a> [auto\_pause\_delay\_in\_minutes](#input\_auto\_pause\_delay\_in\_minutes) | Auto-pause delay in minutes for serverless databases (-1 to disable) | `number` | `-1` | no |
| <a name="input_azuread_administrator"></a> [azuread\_administrator](#input\_azuread\_administrator) | Azure AD administrator configuration | <pre>object({<br/>    login_username = string<br/>    object_id      = string<br/>    tenant_id      = string<br/>  })</pre> | `null` | no |
| <a name="input_backup_interval_in_hours"></a> [backup\_interval\_in\_hours](#input\_backup\_interval\_in\_hours) | Backup interval in hours (12 or 24) | `number` | `12` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | Short-term backup retention days (7-35) | `number` | `7` | no |
| <a name="input_collation"></a> [collation](#input\_collation) | The collation for the database | `string` | `"SQL_Latin1_General_CP1_CI_AS"` | no |
| <a name="input_enable_auditing"></a> [enable\_auditing](#input\_enable\_auditing) | Enable server auditing | `bool` | `false` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | List of firewall rules | <pre>list(object({<br/>    name             = string<br/>    start_ip_address = string<br/>    end_ip_address   = string<br/>  }))</pre> | `[]` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | The license type (LicenseIncluded or BasePrice) | `string` | `"LicenseIncluded"` | no |
| <a name="input_long_term_retention"></a> [long\_term\_retention](#input\_long\_term\_retention) | Long-term retention policy configuration | <pre>object({<br/>    weekly_retention  = string<br/>    monthly_retention = string<br/>    yearly_retention  = string<br/>    week_of_year      = number<br/>  })</pre> | `null` | no |
| <a name="input_max_size_gb"></a> [max\_size\_gb](#input\_max\_size\_gb) | The maximum size of the database in gigabytes | `number` | `4` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Minimum capacity for serverless databases | `number` | `null` | no |
| <a name="input_minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | The minimum TLS version for the SQL Server | `string` | `"1.2"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access is enabled | `bool` | `false` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU name for the database (Basic, S0, S1, P1, GP\_S\_Gen5\_1, etc.) | `string` | `"Basic"` | no |
| <a name="input_sql_version"></a> [sql\_version](#input\_sql\_version) | The version of SQL Server (12.0 for SQL Server 2012) | `string` | `"12.0"` | no |
| <a name="input_storage_account_type"></a> [storage\_account\_type](#input\_storage\_account\_type) | Storage account type for backups (Geo, Local, Zone) | `string` | `"Geo"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_virtual_network_rules"></a> [virtual\_network\_rules](#input\_virtual\_network\_rules) | List of virtual network rules | <pre>list(object({<br/>    name      = string<br/>    subnet_id = string<br/>  }))</pre> | `[]` | no |
| <a name="input_zone_redundant"></a> [zone\_redundant](#input\_zone\_redundant) | Enable zone redundancy for the database | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_string"></a> [connection\_string](#output\_connection\_string) | The connection string for the database |
| <a name="output_database_id"></a> [database\_id](#output\_database\_id) | The ID of the SQL Database |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | The name of the SQL Database |
| <a name="output_server_fqdn"></a> [server\_fqdn](#output\_server\_fqdn) | The fully qualified domain name of the SQL Server |
| <a name="output_server_id"></a> [server\_id](#output\_server\_id) | The ID of the SQL Server |
<!-- END_TF_DOCS -->
