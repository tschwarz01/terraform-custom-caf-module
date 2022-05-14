

#
# Private endpoint
#

module "private_endpoint" {
  source   = "../../networking/private_endpoint"
  for_each = try(var.settings.private_endpoints, {})

  resource_id         = azurerm_key_vault.keyvault.id
  name                = each.value.name
  location            = var.resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = var.resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].name
  subnet_id           = can(each.value.subnet_id) ? each.value.subnet_id : var.vnets[each.value.vnet_key].subnets[each.value.subnet_key].id
  settings            = each.value
  global_settings     = var.global_settings
  base_tags           = try(merge(var.base_tags, each.value.tags), {})
  private_dns         = var.private_dns
  client_config       = var.client_config
}
