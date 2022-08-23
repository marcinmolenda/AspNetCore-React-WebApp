terraform {
  backend "azurerm"{}
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.10"
    }
    azurecaf = {
        source = "aztfmod/azurecaf"
        version = "1.2.6"
    }
    }
}

    provider "azurerm" {
        use_oidc = true
        features {}
    }

resource "azurecaf_name" "this" {
    resource_types = [ "azurerm_resource_group","azurerm_app_service_plan" ]
    name = "weu"
    prefixes = [ "demo" ]
    clean_input = true
  
}

resource "azurerm_resource_group" "this" {
  name     = azurecaf_name.this.results["azurerm_resource_group"]
  location = "West Europe"
}

resource "azurerm_app_service_plan" "this" {
  name                = azurecaf_name.this.results["azurerm_app_service_plan"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}