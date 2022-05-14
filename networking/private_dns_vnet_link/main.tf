terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 0.1.1"
    }
  }

}

locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags = merge(var.base_tags, local.module_tag, var.tags)
}
