output "mssql_elastic_pools" {
  value = module.mssql_elastic_pools

}

module "mssql_elastic_pools" {
  source = "./databases/mssql_elastic_pool"
  for_each = {
    for key, value in local.database.mssql_elastic_pools : key => value
  }

  global_settings     = local.global_settings
  settings            = each.value
  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group_key, each.value.resource_group.key)].name
  server_name         = module.mssql_servers[each.value.mssql_server_key].name
}
