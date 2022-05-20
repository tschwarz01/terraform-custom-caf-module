terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.6"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.4.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 0.2.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2.17"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.15"
}


data "azurerm_subscription" "primary" {}
data "azurerm_client_config" "current" {}


data "azuread_service_principal" "logged_in_app" {
  count          = var.logged_aad_app_objectId == null ? 0 : 1
  application_id = data.azurerm_client_config.current.client_id
}
