variable "server_name" {
  description = "The name of the SQL Server"
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

variable "sql_version" {
  description = "The version of SQL Server (12.0 for SQL Server 2012)"
  type        = string
  default     = "12.0"
}

variable "administrator_login" {
  description = "The administrator login name for the SQL Server"
  type        = string
}

variable "administrator_login_password" {
  description = "The administrator login password"
  type        = string
  sensitive   = true
}

variable "minimum_tls_version" {
  description = "The minimum TLS version for the SQL Server"
  type        = string
  default     = "1.2"
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled"
  type        = bool
  default     = false
}

variable "azuread_administrator" {
  description = "Azure AD administrator configuration"
  type = object({
    login_username = string
    object_id      = string
    tenant_id      = string
  })
  default = null
}

variable "database_name" {
  description = "The name of the SQL Database"
  type        = string
}

variable "collation" {
  description = "The collation for the database"
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "license_type" {
  description = "The license type (LicenseIncluded or BasePrice)"
  type        = string
  default     = "LicenseIncluded"
}

variable "max_size_gb" {
  description = "The maximum size of the database in gigabytes"
  type        = number
  default     = 4
}

variable "sku_name" {
  description = "The SKU name for the database (Basic, S0, S1, P1, GP_S_Gen5_1, etc.)"
  type        = string
  default     = "Basic"
}

variable "zone_redundant" {
  description = "Enable zone redundancy for the database"
  type        = bool
  default     = false
}

variable "auto_pause_delay_in_minutes" {
  description = "Auto-pause delay in minutes for serverless databases (-1 to disable)"
  type        = number
  default     = -1
}

variable "min_capacity" {
  description = "Minimum capacity for serverless databases"
  type        = number
  default     = null
}

variable "storage_account_type" {
  description = "Storage account type for backups (Geo, Local, Zone)"
  type        = string
  default     = "Geo"
}

variable "backup_retention_days" {
  description = "Short-term backup retention days (7-35)"
  type        = number
  default     = 7
}

variable "backup_interval_in_hours" {
  description = "Backup interval in hours (12 or 24)"
  type        = number
  default     = 12
}

variable "long_term_retention" {
  description = "Long-term retention policy configuration"
  type = object({
    weekly_retention  = string
    monthly_retention = string
    yearly_retention  = string
    week_of_year      = number
  })
  default = null
}

variable "firewall_rules" {
  description = "List of firewall rules"
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  default = []
}

variable "virtual_network_rules" {
  description = "List of virtual network rules"
  type = list(object({
    name      = string
    subnet_id = string
  }))
  default = []
}

variable "enable_auditing" {
  description = "Enable server auditing"
  type        = bool
  default     = false
}

variable "auditing_storage_endpoint" {
  description = "Storage account endpoint for auditing"
  type        = string
  default     = null
}

variable "auditing_storage_access_key" {
  description = "Storage account access key for auditing"
  type        = string
  sensitive   = true
  default     = null
}

variable "auditing_retention_days" {
  description = "Number of days to retain audit logs"
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
