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
  tags = merge(var.base_tags, local.module_tag, try(var.settings.tags, null))

  location       = can(var.settings.region) ? var.global_settings.regions[var.settings.region] : try(var.location, local.resource_group.location)
  resource_group = try(var.resource_groups[var.settings.resource_group_key], null)
}
