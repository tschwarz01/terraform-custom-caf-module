module "load_balancers" {
  source   = "./networking/load_balancers"
  for_each = try(local.networking.load_balancers, {})

  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group_key, each.value.resource_group.key)].name
  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  public_ip_addresses = local.combined_objects_public_ip_addresses
  client_config       = local.client_config
  vnets               = local.combined_objects_networking
  diagnostic_profiles = try(each.value.diagnostic_profiles, null)
  diagnostics         = local.combined_diagnostics
  global_settings     = local.global_settings
  settings            = each.value
  existing_resources = {
    virtual_machines = try(module.virtual_machines, {})
    #vm scale set will be added later
  }
}

output "load_balancers" {
  value = module.load_balancers
}
