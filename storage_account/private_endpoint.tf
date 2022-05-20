module "private_endpoint" {
  source   = "../networking/private_endpoint"
  for_each = var.remote_objects.private_endpoints

  resource_id         = azurerm_storage_account.stg.id
  subnet_id           = can(each.value.subnet_id) ? each.value.subnet_id : var.vnets[each.value.vnet_key].subnets[each.value.subnet_key].id
  name                = each.value.name
  client_config       = var.client_config
  global_settings     = var.global_settings
  settings            = each.value
  location            = var.resource_groups[each.value.resource_group_key].location
  resource_group_name = var.resource_groups[each.value.resource_group_key].name
  base_tags           = local.tags
  private_dns         = var.private_dns
}

