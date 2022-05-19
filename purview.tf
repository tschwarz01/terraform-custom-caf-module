module "purview_accounts" {
  source   = "./purview/purview_accounts"
  for_each = local.purview.purview_accounts

  client_config       = local.client_config
  diagnostics         = local.combined_diagnostics
  global_settings     = local.global_settings
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group_key, each.value.resource_group.key)].name
  settings            = each.value

  remote_objects = {
    private_dns                        = local.combined_objects_private_dns
    private_endpoints                  = try(each.value.private_endpoints, {})
    managed_resource_private_endpoints = try(each.value.managed_resource_private_endpoints, {})
    resource_groups                     = local.combined_objects_resource_groups
    vnets                              = local.combined_objects_networking
  }
}
output "purview_accounts" {
  value = module.purview_accounts
}


