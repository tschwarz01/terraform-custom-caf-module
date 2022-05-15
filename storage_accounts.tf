
module "storage_accounts" {
  source   = "./storage_account"
  for_each = var.storage_accounts

  global_settings     = local.global_settings
  client_config       = local.client_config
  storage_account     = each.value
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group_key, each.value.resource_group.key)].name
  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  recovery_vaults     = local.combined_objects_recovery_vaults


  #vnets             = local.combined_objects_networking
  #private_endpoints = try(each.value.private_endpoints, {})
  #private_dns       = local.combined_objects_private_dns

  remote_objects = {
    resource_groups    = try(each.value.private_endpoints, {}) == {} ? null : local.combined_objects_resource_groups
    managed_identities = local.combined_objects_managed_identities
    vnets              = local.combined_objects_networking
    private_dns        = local.combined_objects_private_dns
    private_endpoints  = try(each.value.private_endpoints, {})
  }

}

output "storage_accounts" {
  value     = module.storage_accounts
  sensitive = true
}

resource "azurerm_storage_account_customer_managed_key" "cmk" {
  depends_on = [module.keyvault_access_policies]
  for_each = {
    for key, value in var.storage_accounts : key => value
    if try(value.customer_managed_key, null) != null
  }

  storage_account_id = module.storage_accounts[each.key].id
  key_vault_id       = module.keyvaults[each.value.customer_managed_key.keyvault_key].id
  key_name           = module.keyvault_keys[each.value.customer_managed_key.keyvault_key_key].name
}
