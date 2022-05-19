module "container_registry" {
  source   = "./compute/container_registry"
  for_each = local.compute.azure_container_registries

  global_settings               = local.global_settings
  client_config                 = local.client_config
  settings                      = each.value
  name                          = each.value.name
  admin_enabled                 = try(each.value.admin_enabled, false)
  sku                           = try(each.value.sku, "Basic")
  tags                          = try(each.value.tags, {})
  network_rule_set              = try(each.value.network_rule_set, {})
  georeplications               = try(each.value.georeplications, {})
  diagnostics                   = local.combined_diagnostics
  diagnostic_profiles           = try(each.value.diagnostic_profiles, {})
  base_tags                     = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  retention_policy              = try(each.value.retention_policy, {})
  trust_policy                  = try(each.value.trust_policy, {})
  public_network_access_enabled = try(each.value.public_network_access_enabled, "true")
  quarantine_policy_enabled     = try(each.value.quarantine_policy_enabled, "false")
  anonymous_pull_enabled        = try(each.value.anonymous_pull_enabled, null)
  data_endpoint_enabled         = try(each.value.data_endpoint_enabled, null)
  network_rule_bypass_option    = try(each.value.network_rule_bypass_option, "None")

  remote_objects = {
    managed_identities = local.combined_objects_managed_identities
    vnets              = local.combined_objects_networking
    private_endpoints  = try(each.value.private_endpoints, {})
    private_dns        = local.combined_objects_private_dns
    resource_groups    = try(local.combined_objects_resource_groups, null)
  }
}

output "azure_container_registries" {
  value = module.container_registry
}
