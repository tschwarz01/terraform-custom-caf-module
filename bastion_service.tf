#
# Bastion host service
# https://www.terraform.io/docs/providers/azurerm/r/bastion_host.html
#

resource "azurecaf_name" "host" {
  for_each = try(local.compute.bastion_hosts, {})

  name          = try(each.value.name, "")
  resource_type = "azurerm_bastion_host"
  prefixes      = local.global_settings.prefixes
  random_length = local.global_settings.random_length
  clean_input   = true
  passthrough   = local.global_settings.passthrough
  use_slug      = local.global_settings.use_slug
}

# Last updated with :  AzureRM version 2.64.0
# Ref : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host

resource "azurerm_bastion_host" "host" {
  depends_on = [
    module.public_ip_addresses
  ]
  for_each = try(local.compute.bastion_hosts, {})

  name = azurecaf_name.host[each.key].result
  tags = try(local.global_settings.inherit_tags, false) ? merge(local.resource_groups[each.value.resource_group_key].tags, try(each.value.tags, null)) : try(each.value.tags, null)

  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = can(each.value.resource_group.name) ? each.value.resource_group.name : local.combined_objects_resource_groups[try(each.value.resource_group_key, each.value.resource_group.key)].name
  sku                 = try(each.value.sku, null)

  ip_configuration {
    name                 = each.value.name
    subnet_id            = local.combined_objects_networking[try(each.value.vnet.vnet_key, each.value.vnet_key)].subnets[try(each.value.vnet.subnet_key, each.value.subnet_key)].id
    public_ip_address_id = can(each.value.public_ip.id) ? each.value.public_ip.id : local.combined_objects_public_ip_addresses[try(each.value.public_ip.key, each.value.public_ip_key, each.value.public_ip.public_ip_key)].id
  }

  timeouts {
    create = "60m"
  }
}

module "bastion_host_diagnostics" {
  source   = "./diagnostics"
  for_each = try(local.compute.bastion_hosts, {})

  resource_id = azurerm_bastion_host.host[each.key].id
  diagnostics = local.combined_diagnostics
  profiles    = try(each.value.diagnostic_profiles, {})

  resource_location = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].location

}
