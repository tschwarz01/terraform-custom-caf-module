module "private_endpoint" {
  source   = "../private_endpoint"
  for_each = var.remote_objects.private_endpoints

  resource_id         = azurerm_synapse_private_link_hub.plh.id
  name                = each.value.name
  resource_group_name = var.remote_objects.resource_groups[each.value.resource_group_key].name
  location            = var.location
  subnet_id           = can(each.value.subnet_id) ? each.value.subnet_id : var.remote_objects.vnets[each.value.vnet_key].subnets[each.value.subnet_key].id
  settings            = each.value
  global_settings     = var.global_settings
  base_tags           = var.base_tags
  private_dns         = var.remote_objects.private_dns
  #client_config       = var.client_config
}
