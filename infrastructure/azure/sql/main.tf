# Azure SQL Database Module
# Creates an Azure SQL Server and Database with security configurations

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# SQL Server
resource "azurerm_mssql_server" "main" {
  name                         = var.server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sql_version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password

  minimum_tls_version = var.minimum_tls_version

  public_network_access_enabled = var.public_network_access_enabled

  dynamic "azuread_administrator" {
    for_each = var.azuread_administrator != null ? [var.azuread_administrator] : []
    content {
      login_username = azuread_administrator.value.login_username
      object_id      = azuread_administrator.value.object_id
      tenant_id      = azuread_administrator.value.tenant_id
    }
  }

  tags = var.tags
}

# SQL Database
resource "azurerm_mssql_database" "main" {
  name      = var.database_name
  server_id = azurerm_mssql_server.main.id

  collation      = var.collation
  license_type   = var.license_type
  max_size_gb    = var.max_size_gb
  sku_name       = var.sku_name
  zone_redundant = var.zone_redundant

  auto_pause_delay_in_minutes = var.auto_pause_delay_in_minutes
  min_capacity                = var.min_capacity

  storage_account_type = var.storage_account_type

  dynamic "short_term_retention_policy" {
    for_each = var.backup_retention_days > 0 ? [1] : []
    content {
      retention_days           = var.backup_retention_days
      backup_interval_in_hours = var.backup_interval_in_hours
    }
  }

  dynamic "long_term_retention_policy" {
    for_each = var.long_term_retention != null ? [var.long_term_retention] : []
    content {
      weekly_retention  = long_term_retention_policy.value.weekly_retention
      monthly_retention = long_term_retention_policy.value.monthly_retention
      yearly_retention  = long_term_retention_policy.value.yearly_retention
      week_of_year      = long_term_retention_policy.value.week_of_year
    }
  }

  tags = var.tags
}

# Firewall Rules
resource "azurerm_mssql_firewall_rule" "rules" {
  for_each = { for rule in var.firewall_rules : rule.name => rule }

  name             = each.value.name
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

# Virtual Network Rule
resource "azurerm_mssql_virtual_network_rule" "vnet_rules" {
  for_each = { for rule in var.virtual_network_rules : rule.name => rule }

  name      = each.value.name
  server_id = azurerm_mssql_server.main.id
  subnet_id = each.value.subnet_id
}

# Auditing Policy
resource "azurerm_mssql_server_extended_auditing_policy" "main" {
  count = var.enable_auditing ? 1 : 0

  server_id                               = azurerm_mssql_server.main.id
  storage_endpoint                        = var.auditing_storage_endpoint
  storage_account_access_key              = var.auditing_storage_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = var.auditing_retention_days
}
