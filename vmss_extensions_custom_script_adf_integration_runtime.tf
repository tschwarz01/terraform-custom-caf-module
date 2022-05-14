
module "vmss_extensions_custom_script_adf_integration_runtime" {
  depends_on = [
    module.virtual_machine_scale_sets,
    module.data_factory_integration_runtime_self_hosted
  ]
  source = "./compute/virtual_machine_scale_set_extensions"

  for_each = local.compute.vmss_extensions_custom_script_adf_integration_runtime

  client_config                = local.client_config
  virtual_machine_scale_set_id = module.virtual_machine_scale_sets[each.value.vmss_key].id
  settings                     = each.value
  extension                    = each.value
  extension_name               = "custom_script"
  #managed_identities                = local.combined_objects_managed_identities
  #storage_accounts                  = local.combined_objects_storage_accounts
  #keyvaults                         = local.combined_objects_keyvaults
  virtual_machine_scale_set_os_type = module.virtual_machine_scale_sets[each.value.vmss_key].os_type

  #commandtoexecute = "${each.value.custom_script.adf_integration_runtime.basecommandtoexecute} ${try(local.combined_objects_data_factory_integration_runtime_self_hosted[value.custom_script.adf_integration_runtime.integration_runtime_key].primary_authorization_key, null)}"
  commandtoexecute = "powershell.exe -ExecutionPolicy Unrestricted -File installSHIRGateway.ps1 -gatewayKey ${local.combined_objects_data_factory_integration_runtime_self_hosted[each.value.integration_runtime_key].primary_authorization_key}"
  fileuris         = [each.value.script_location]

}
