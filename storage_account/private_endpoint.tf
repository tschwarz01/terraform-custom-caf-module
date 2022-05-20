module "private_endpoint" {
  source   = "../networking/private_endpoint"
  for_each = var.remote_objects.private_endpoints

  resource_id         = azurerm_storage_account.stg.id
  subnet_id           = can(each.value.subnet_id) ? each.value.subnet_id : try(var.remote_objects.vnets[each.value.vnet_key].subnets[each.value.subnet_key].id, var.vnets[each.value.vnet_key].subnets[each.value.subnet_key].id)
  name                = each.value.name
  client_config       = var.client_config
  global_settings     = var.global_settings
  settings            = each.value
  location            = try(var.remote_objects.resource_groups[each.value.resource_group_key].location, var.resource_groups[each.value.resource_group_key].location)
  resource_group_name = try(var.remote_objects.resource_groups[each.value.resource_group_key].name, var.resource_groups[each.value.resource_group_key].name)
  base_tags           = local.tags
  private_dns         = try(var.remote_objects.private_dns, var.private_dns, {})
}

