terraform {
  backend "azurerm"{
    use_oidc             = true
  }
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.10"
    }
    azurecaf = {
        source = "aztfmod/azurecaf"
        version = "1.2.6"
    }

    random = {
        source = "hashicorp/random"
        version = "3.3.2"
    }
  }
}

    provider "azurerm" {
        subscription_id    = var.subscription_id
        client_id          = var.client_id
        tenant_id          = var.tenant_id
        use_oidc = true
        features {}
    }

resource "azurecaf_name" "this" {
    resource_types = [ 
        "azurerm_resource_group",
        "azurerm_app_service",
        "azurerm_sql_server"
    ]
    name = "weu"
    prefixes = [ "demo" ]
    suffixes = [ "backend" ]
    clean_input = true
  
}

resource "azurerm_resource_group" "this" {
  name     = azurecaf_name.this.results["azurerm_resource_group"]
  location = "West Europe"
}

resource "azurerm_app_service" "this" {
  name                = azurecaf_name.this.results["azurerm_app_service"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  app_service_plan_id = data.terraform_remote_state.infrastructure.outputs.app_service_plan.id
  connection_string {
    name  = "ConnectionStrings__Database"
    type  = "SQLServer"
    value = "Server=tcp:${azurerm_sql_server.this.name}.database.windows.net,1433;Initial Catalog=${azurerm_sql_database.this.name};Persist Security Info=False;User ID=${azurerm_sql_server.this.administrator_login};Password=${random_password.this.result};MultipleActiveResultSets=True;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
  site_config {
    dotnet_framework_version = "v6.0"
  }
}

resource "random_password" "this" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_sql_server" "this" {
  name                         = azurecaf_name.this.results["azurerm_sql_server"]
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = random_password.this.result

  tags = {
    environment = "production"
  }
}

resource "azurerm_sql_database" "this" {
  name                = "sqldatabasebackend1"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  server_name         = azurerm_sql_server.this.name
  tags = {
    environment = "production"
  }
}