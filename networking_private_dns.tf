

module "private_dns" {
  source   = "./networking/private-dns"
  for_each = local.networking.private_dns

  global_settings     = local.global_settings
  client_config       = local.client_config
  name                = each.value.name
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group_key, each.value.resource_group.key)].name
  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  records             = try(each.value.records, {})
  vnet_links          = try(each.value.vnet_links, {})
  tags                = try(each.value.tags, null)
  vnets               = local.combined_objects_networking
}

output "private_dns" {
  value = module.private_dns
}

#
# Create vnet links on remote DNS zones
#

module "private_dns_vnet_links" {
  source   = "./networking/private_dns_vnet_link"
  for_each = try(local.networking.private_dns_vnet_links, {})
  #depends_on = [module.private_dns]

  base_tags          = {}
  global_settings    = local.global_settings
  client_config      = local.client_config
  virtual_network_id = local.combined_objects_networking[each.value.vnet_key].id
  private_dns        = local.combined_objects_private_dns
  settings           = each.value
}

output "private_dns_vnet_links" {
  value = module.private_dns_vnet_links
}
