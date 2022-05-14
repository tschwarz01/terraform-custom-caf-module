

module "virtual_machines" {
  source = "./compute/virtual_machine"
  depends_on = [
    #module.availability_sets,
    module.dynamic_keyvault_secrets,
    module.keyvault_access_policies,
    #module.keyvault_access_policies_azuread_apps,
    #module.proximity_placement_groups,
    module.network_security_groups,
    module.storage_account_blobs,
    #module.packer_service_principal,
    #module.packer_build,
    #module.proximity_placement_groups
  ]
  for_each = local.compute.virtual_machines

  application_security_groups = local.combined_objects_application_security_groups
  #availability_sets           = local.combined_objects_availability_sets
  client_config = local.client_config
  #dedicated_hosts             = local.combined_objects_dedicated_hosts
  diagnostics = local.combined_diagnostics
  #disk_encryption_sets        = local.combined_objects_disk_encryption_sets
  global_settings = local.global_settings
  #image_definitions           = local.combined_objects_image_definitions
  keyvaults = local.combined_objects_keyvaults
  #managed_identities          = local.combined_objects_managed_identities
  network_security_groups = local.combined_objects_network_security_groups
  #proximity_placement_groups  = local.combined_objects_proximity_placement_groups
  public_ip_addresses = local.combined_objects_public_ip_addresses
  #recovery_vaults             = local.combined_objects_recovery_vaults
  settings         = each.value
  storage_accounts = local.combined_objects_storage_accounts
  vnets            = local.combined_objects_networking

  # if boot_diagnostics_storage_account_key is points to a valid storage account, pass the endpoint
  # if boot_diagnostics_storage_account_key is empty string, pass empty string
  # if boot_diagnostics_storage_account_key not defined, pass null
  # otherwise, boot_diagnostics_storage_account_key is a non-empty string that does not reference a valid storage account, so blow-up
  boot_diagnostics_storage_account = try(local.combined_diagnostics.storage_accounts[each.value.boot_diagnostics_storage_account_key].primary_blob_endpoint,
    each.value.boot_diagnostics_storage_account_key == "" ? "" : each.value.throw_error,
  can(tostring(each.value.boot_diagnostics_storage_account_key)) ? each.value.throw_error : null)

  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group_key, each.value.resource_group.key)].name
  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
}


output "virtual_machines" {
  value = module.virtual_machines

}

