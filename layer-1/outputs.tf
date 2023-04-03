output "resource_group_id" {
  value = azurerm_resource_group.rg-logic-app-rss-gmail.id
}

output "rss_connection_id" {
  value = azapi_resource.rss_connection.id
}

output "gmail_connection_id" {
  value = azapi_resource.gmail_connection.id
}
