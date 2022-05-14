terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
  }

}
locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags                = merge(var.base_tags, local.module_tag, try(var.tags, null))
  location            = can(var.settings.location) ? var.settings.location : var.resource_groups[try(var.settings.resource_group.key, var.settings.resource_group_key)].location
  resource_group_name = can(var.settings.resource_group_name) || can(var.settings.resource_group.name) ? try(var.settings.resource_group_name, var.settings.resource_group.name) : var.resource_groups[try(var.settings.resource_group_key, var.settings.resource_group.key)].name
}
