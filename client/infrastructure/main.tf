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
        "azurerm_app_service"
    ]
    name = "weu"
    prefixes = [ "demo" ]
    suffixes = [ "frontend" ]
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
site_config {
    linux_fx_version = "NODE|14-lts"
    app_command_line = "pm2 serve /home/site/wwwroot --no-daemon --spa"
  }
}