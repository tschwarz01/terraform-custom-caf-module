##### azurerm_data_factory
module "data_factory" {
  source   = "./data_factory/data_factory"
  for_each = local.data_factory.data_factory

  global_settings     = local.global_settings
  client_config       = local.client_config
  settings            = each.value
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group_key, each.value.resource_group.key)].name
  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}

  remote_objects = {
    managed_identities = local.combined_objects_managed_identities
    vnets              = local.combined_objects_networking
    private_endpoints  = try(each.value.private_endpoints, {})
    private_dns        = local.combined_objects_private_dns
    resource_groups    = try(each.value.private_endpoints, {}) == {} ? null : local.combined_objects_resource_groups
  }
}

output "data_factory" {
  value = module.data_factory
}

module "data_factory_integration_runtime_self_hosted" {
  source   = "./data_factory/data_factory_integration_runtime_self_hosted"
  for_each = local.data_factory.data_factory_integration_runtime_self_hosted


  global_settings = local.global_settings
  client_config   = local.client_config
  settings        = each.value
  data_factory_id = can(each.value.data_factory.id) ? each.value.data_factory.id : local.combined_objects_data_factory[each.value.data_factory.key].id
  #host_runtime_resource_id = try(can(each.value.host_data_factory.runtime_resource_id) ? each.value.host_data_factory.runtime_resource_id : local.combined_objects_data_factory_integration_runtime_self_hosted[each.value.host_data_factory.runtime_key].id, null)

  remote_objects = {
    data_factory = local.combined_objects_data_factory
    #data_factory_integration_runtime_self_hosted = try(local.combined_objects_data_factory_integration_runtime_self_hosted, null)
    resource_group = local.combined_objects_resource_groups
  }
}
output "data_factory_integration_runtime_self_hosted" {
  value = module.data_factory_integration_runtime_self_hosted
}

resource "azurerm_role_assignment" "target" {
  for_each = local.data_factory.data_factory_integration_runtime_shared_self_hosted

  scope                = try(can(each.value.host_data_factory.resource_id) ? each.value.host_data_factory.resource_id : local.combined_objects_data_factory[each.value.host_data_factory.key].id, null)
  role_definition_name = "Contributor"
  principal_id         = can(each.value.data_factory.principal_id) ? each.value.data_factory.principal_id : try(module.data_factory[each.value.data_factory.key].identity[0].principal_id, null)
}

resource "time_sleep" "shirdelay" {
  depends_on      = [azurerm_role_assignment.target]
  create_duration = "75s"
}

module "data_factory_integration_runtime_shared_self_hosted" {
  depends_on = [
    time_sleep.shirdelay, module.data_factory_integration_runtime_self_hosted
  ]
  source   = "./data_factory/data_factory_integration_runtime_shared_self_hosted"
  for_each = local.data_factory.data_factory_integration_runtime_shared_self_hosted

  global_settings          = local.global_settings
  client_config            = local.client_config
  settings                 = each.value
  data_factory_id          = can(each.value.data_factory.id) ? each.value.data_factory.id : local.combined_objects_data_factory[each.value.data_factory.key].id
  host_runtime_resource_id = try(can(each.value.host_data_factory.runtime_resource_id) ? each.value.host_data_factory.runtime_resource_id : module.data_factory_integration_runtime_self_hosted[each.value.host_data_factory.runtime_key].id, null)

  remote_objects = {
    data_factory = local.combined_objects_data_factory
    #data_factory_integration_runtime_self_hosted = try(local.combined_objects_data_factory_integration_runtime_self_hosted, null)
    resource_group = local.combined_objects_resource_groups
  }
}
output "data_factory_integration_runtime_shared_self_hosted" {
  value = module.data_factory_integration_runtime_shared_self_hosted
}

/*
module "data_factory_integration_runtime_shared_self_hosted" {
  source   = "./data_factory/data_factory_integration_runtime_shared_self_hosted"
  for_each = local.data_factory.data_factory_integration_runtime_shared_self_hosted

  global_settings = local.global_settings
  client_config   = local.client_config
  settings        = each.value

  data_factory_id    = can(each.value.data_factory.id) ? each.value.data_factory.id : local.combined_objects_data_factory[each.value.data_factory.key].id
  data_factory_mi_id = can(each.value.data_factory.id) ? each.value.data_factory.id : try(local.combined_objects_data_factory[each.value.data_factory.key].identity[0].principal_id, null)

  shared_runtime_resource_id     = try(can(each.value.existing_data_factory.runtime_resource_id) ? each.value.existing_data_factory.runtime_resource_id : local.combined_objects_data_factory_integration_runtime_self_hosted[each.value.existing_data_factory.runtime_key].id, null)
  shared_runtime_data_factory_id = try(can(each.value.existing_data_factory.resource_id) ? each.value.existing_data_factory.resource_id : local.combined_objects_data_factory[each.value.existing_data_factory.key].id, null)

  remote_objects = {
    data_factory   = local.combined_objects_data_factory
    resource_group = local.combined_objects_resource_groups
  }
}
output "data_factory_integration_runtime_shared_self_hosted" {
  value = module.data_factory_integration_runtime_shared_self_hosted
}

module "data_factory_integration_runtime_azure_ssis" {
  source   = "./data_factory/data_factory_integration_runtime_azure_ssis"
  for_each = local.data_factory.data_factory_integration_runtime_azure_ssis

  global_settings = local.global_settings
  client_config   = local.client_config
  settings        = each.value

  data_factory_name   = can(each.value.data_factory.name) ? each.value.data_factory.name : local.combined_objects_data_factory[each.value.data_factory.key].name
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group_key, each.value.resource_group.key)].name
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].location


  remote_objects = {
    resource_groups          = local.combined_objects_resource_groups
    keyvaults                = local.combined_objects_keyvaults
    dynamic_keyvault_secrets = local.security.dynamic_keyvault_secrets
  }
}
output "data_factory_integration_runtime_azure_ssis" {
  value = module.data_factory_integration_runtime_azure_ssis
}


##### azurerm_data_factory_pipeline
module "data_factory_pipeline" {
  source   = "./data_factory/data_factory_pipeline"
  for_each = local.data_factory.data_factory_pipeline

  global_settings = local.global_settings
  client_config   = local.client_config
  settings        = each.value

  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group_key, each.value.resource_group.key)].name
  data_factory_name   = can(each.value.data_factory.name) ? each.value.data_factory.name : local.combined_objects_data_factory[each.value.data_factory.key].name
}

output "data_factory_pipeline" {
  value = module.data_factory_pipeline
}

##### azurerm_data_factory_trigger_schedule
module "data_factory_trigger_schedule" {
  source   = "./data_factory/data_factory_trigger_schedule"
  for_each = local.data_factory.data_factory_trigger_schedule

  global_settings = local.global_settings
  client_config   = local.client_config
  settings        = each.value

  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group_key, each.value.resource_group.key)].name
  data_factory_name   = can(each.value.data_factory.name) ? each.value.data_factory.name : local.combined_objects_data_factory[each.value.data_factory.key].name
  pipeline_name       = can(each.value.data_factory_pipeline.name) ? each.value.data_factory_pipeline.name : local.combined_objects_data_factory_pipeline[each.value.data_factory_pipeline.key].name
}

output "data_factory_trigger_schedule" {
  value = module.data_factory_trigger_schedule
}

*/
