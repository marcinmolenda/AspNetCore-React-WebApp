output "app_service_plan" {
  value = {
    name = azurerm_app_service_plan.this.name
    resource_group_name = azurerm_resource_group.this.name
  }
}