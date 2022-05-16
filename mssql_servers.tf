
output "mssql_servers" {
  value = module.mssql_servers

}

module "mssql_servers" {
  source     = "./databases/mssql_server"
  depends_on = [module.keyvault_access_policies, module.keyvault_access_policies_azuread_apps]
  for_each   = local.database.mssql_servers

  global_settings     = local.global_settings
  client_config       = local.client_config
  settings            = each.value
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group_key, each.value.resource_group.key)].name
  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  keyvault_id = coalesce(
    try(each.value.administrator_login_password, null),
    try(module.keyvaults[each.value.keyvault_key].id, null),
    try(local.combined_objects_keyvaults[each.value.keyvault.lz_key][each.value.keyvault.key].id, null),
    try(local.combined_objects_keyvaults[local.client_config.landingzone_key][each.value.keyvault.key].id, null)
  )
  remote_objects = {
    resource_groups   = local.combined_objects_resource_groups
    azuread_groups    = local.combined_objects_azuread_groups
    storage_accounts  = module.storage_accounts
    keyvault_keys     = local.combined_objects_keyvault_keys
    vnets             = local.combined_objects_networking
    private_endpoints = try(each.value.private_endpoints, {})
    private_dns       = local.combined_objects_private_dns
  }
}

data "azurerm_storage_account" "mssql_auditing" {
  for_each = {
    for key, value in local.database.mssql_servers : key => value
    if try(value.extended_auditing_policy, null) != null
  }

  name                = module.storage_accounts[each.value.extended_auditing_policy.storage_account.key].name
  resource_group_name = module.storage_accounts[each.value.extended_auditing_policy.storage_account.key].resource_group_name
}


resource "azurerm_mssql_server_extended_auditing_policy" "mssql" {
  depends_on = [azurerm_role_assignment.for]
  for_each = {
    for key, value in local.database.mssql_servers : key => value
    if try(value.extended_auditing_policy, null) != null
  }

  log_monitoring_enabled                  = try(each.value.extended_auditing_policy.log_monitoring_enabled, false)
  server_id                               = module.mssql_servers[each.key].id
  storage_endpoint                        = data.azurerm_storage_account.mssql_auditing[each.key].primary_blob_endpoint
  storage_account_access_key              = data.azurerm_storage_account.mssql_auditing[each.key].primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = try(each.value.extended_auditing_policy.retention_in_days, null)
}

module "mssql_failover_groups" {
  source   = "./databases/mssql_server/failover_group"
  for_each = local.database.mssql_failover_groups

  global_settings     = local.global_settings
  client_config       = local.client_config
  settings            = each.value
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
  primary_server_name = local.combined_objects_mssql_servers[try(each.value.primary_server.lz_key, local.client_config.landingzone_key)][each.value.primary_server.sql_server_key].name
  secondary_server_id = local.combined_objects_mssql_servers[try(each.value.secondary_server.lz_key, local.client_config.landingzone_key)][each.value.secondary_server.sql_server_key].id
  databases           = local.combined_objects_mssql_databases
}
