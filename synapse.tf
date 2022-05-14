module "synapse_workspaces" {
  source     = "./analytics/synapse"
  depends_on = [module.keyvault_access_policies, module.keyvault_access_policies_azuread_apps]
  for_each   = local.database.synapse_workspaces

  global_settings                      = local.global_settings
  settings                             = each.value
  storage_data_lake_gen2_filesystem_id = can(each.value.storage_data_lake_gen2_filesystem_id) || can(each.value.data_lake_filesystem.container_key) == false ? try(each.value.storage_data_lake_gen2_filesystem_id, null) : local.combined_objects_storage_accounts[each.value.data_lake_filesystem.storage_account_key].data_lake_filesystems[each.value.data_lake_filesystem.container_key].id
  keyvault_id                          = try(each.value.sql_administrator_login_password, null) == null ? module.keyvaults[each.value.keyvault_key].id : null
  location                             = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name                  = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group_key, each.value.resource_group.key)].name
  base_tags                            = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}

}

output "synapse_workspaces" {
  value = module.synapse_workspaces

}

module "synpase_privatelink_hubs" {
  source   = "./networking/synapse_private_link_hub"
  for_each = local.networking.synapse_privatelink_hubs

  global_settings     = local.global_settings
  settings            = each.value
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group_key, each.value.resource_group.key)].name
  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}

  remote_objects = {
    managed_identities = local.combined_objects_managed_identities
    private_dns        = local.combined_objects_private_dns
    vnets              = local.combined_objects_networking
    private_endpoints  = try(each.value.private_endpoints, {})
    resource_groups    = try(each.value.private_endpoints, {}) == {} ? null : local.combined_objects_resource_groups
  }
}
