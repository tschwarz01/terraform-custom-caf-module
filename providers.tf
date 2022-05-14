terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 0.1.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.4.0"
    }
  }
}
