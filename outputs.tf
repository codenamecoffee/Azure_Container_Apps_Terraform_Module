# Public URL where the API can be accessed.
output "app_url" {
  description = "Public URL to access the Container App"
  value       = "https://${azurerm_container_app.app.latest_revision_fqdn}" # Azure automatically generates a unique domain.
}

# Internal ID of the Container application.
output "app_id" {
  description = "ID of the created Container App"
  value       = azurerm_container_app.app.id
}

# Container App Name (for confirmation).
output "app_name" {
  description = "Name of the Container App"
  value       = azurerm_container_app.app.name
}

# Full FQDN (technical name of the URL).
output "app_fqdn" {
  description = "Fully Qualified Domain Name of the Container App"
  value       = azurerm_container_app.app.latest_revision_fqdn
}

# Name of the Blob Storage Container created.
output "blob_container_name" {
  description = "Name of the created Blob Storage Container"
  value       = azurerm_storage_container.blob.name
}
