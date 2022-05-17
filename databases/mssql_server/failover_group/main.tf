terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
  }

}

locals {
  databases = [
    for key, value in var.settings.databases : var.databases[value.database_key].id
  ]

  module_tag = {
    "module" = basename(abspath(path.module))
  }

  tags = merge(local.module_tag, try(var.settings.tags, null), var.base_tags)
}
