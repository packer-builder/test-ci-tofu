output "server_id" {
  description = "The ID of the SQL Server"
  value       = azurerm_mssql_server.main.id
}

output "server_fqdn" {
  description = "The fully qualified domain name of the SQL Server"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "database_id" {
  description = "The ID of the SQL Database"
  value       = azurerm_mssql_database.main.id
}

output "database_name" {
  description = "The name of the SQL Database"
  value       = azurerm_mssql_database.main.name
}

output "connection_string" {
  description = "The connection string for the database"
  value       = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Database=${azurerm_mssql_database.main.name};Encrypt=true;Connection Timeout=30;"
  sensitive   = true
}
