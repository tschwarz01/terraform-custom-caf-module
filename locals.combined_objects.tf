locals {
  combined_objects_azuread_apps                                          = {}
  combined_objects_application_security_groups                           = module.application_security_groups
  combined_objects_azuread_groups                                        = {}
  combined_objects_azuread_service_principals                            = {}
  combined_objects_azure_container_registries                            = module.container_registry
  combined_objects_container_registry                                    = module.container_registry
  combined_objects_data_factory                                          = module.data_factory
  combined_objects_data_factory_integration_runtime_self_hosted          = module.data_factory_integration_runtime_self_hosted
  combined_objects_diagnostic_storage_accounts                           = {}
  combined_objects_disk_encryption_sets                                  = module.disk_encryption_sets
  combined_objects_keyvaults                                             = module.keyvaults
  combined_objects_keyvault_keys                                         = module.keyvault_keys
  combined_objects_lb                                                    = module.lb
  combined_objects_lb_backend_address_pool                               = module.lb_backend_address_pool
  combined_objects_load_balancers                                        = module.load_balancers
  combined_objects_log_analytics                                         = module.log_analytics
  combined_objects_managed_identities                                    = module.managed_identities
  combined_objects_mssql_managed_instances                               = {}
  combined_objects_mssql_managed_instances_secondary                     = {}
  combined_objects_networking                                            = module.networking
  combined_objects_network_profiles                                      = module.network_profiles
  combined_objects_network_security_groups                               = module.network_security_groups
  combined_objects_public_ip_addresses                                   = module.public_ip_addresses
  combined_objects_public_ip_prefixes                                    = module.public_ip_prefixes
  combined_objects_private_dns                                           = merge(module.private_dns, try(var.remote_objects.private_dns))
  combined_objects_purview_accounts                                      = module.purview_accounts
  combined_objects_recovery_vaults                                       = module.recovery_vaults
  combined_objects_resource_groups                                       = local.resource_groups
  combined_objects_storage_accounts                                      = module.storage_accounts
  combined_objects_storage_containers                                    = module.storage_containers
  combined_objects_synapse_privatelink_hubs                              = module.synpase_privatelink_hubs
  combined_objects_virtual_subnets                                       = module.virtual_subnets
  combined_objects_virtual_machines                                      = module.virtual_machines
  combined_objects_virtual_machine_scale_sets                            = module.virtual_machine_scale_sets
  combined_objects_vmss_extensions_custom_script_adf_integration_runtime = module.vmss_extensions_custom_script_adf_integration_runtime
  #combined_objects_azurerm_firewalls = module.azurerm_firewalls


}
