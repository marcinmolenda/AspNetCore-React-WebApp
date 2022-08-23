output "app_service" {
  value = {
    name = azurerm_app_service.this.name
    resource_group_name = azurerm_resource_group.this.name
  }
}