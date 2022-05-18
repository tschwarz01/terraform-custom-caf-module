
/*
resource "azurerm_private_dns_zone_virtual_network_link" "vnet_links" {
  for_each = var.vnet_links

  name                  = azurecaf_name.pnetlk[each.key].result
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = can(each.value.virtual_network_id) ? each.value.virtual_network_id : var.vnets[each.value.vnet_key].id
  registration_enabled  = try(each.value.registration_enabled, false)
  tags                  = merge(var.base_tags, local.module_tag, try(each.value.tags, null))
}
*/

module "private_dns_vnet_link" {
  source   = "../private_dns_vnet_link"
  for_each = var.vnet_links


  global_settings = var.global_settings
  base_tags       = var.base_tags
  tags            = try(each.value.tags, {})

  name                = try(each.value.name, var.name, "vnet_link")
  virtual_network_id  = try(each.value.vnet_id, var.vnets[each.value.vnet_key].id)
  private_dns_zone_id = azurerm_private_dns_zone.private_dns.id
}
