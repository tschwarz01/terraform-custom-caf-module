terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
  }

}

locals {
  resource_group = coalesce(
    try(var.resource_groups[var.settings.resource_group_key], null),
    try(var.resource_groups[var.settings.resource_group.key], null)
  )
}
