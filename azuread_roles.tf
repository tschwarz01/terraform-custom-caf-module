
module "azuread_roles_security_groups" {
  source   = "./azuread/roles"
  for_each = try(local.azuread.azuread_roles.azuread_groups, {})

  object_id     = module.azuread_groups[each.key].id
  azuread_roles = each.value.roles
}

module "azuread_roles_applications" {
  source   = "./azuread/roles"
  for_each = try(local.azuread.azuread_roles.azuread_apps, {})

  object_id     = module.azuread_applications[each.key].azuread_service_principal.object_id
  azuread_roles = each.value.roles
}

module "azuread_roles_service_principals" {
  source   = "./azuread/roles"
  for_each = try(local.azuread.azuread_roles.azuread_service_principals, {})

  object_id     = module.azuread_service_principals[each.key].object_id
  azuread_roles = each.value.roles
}

module "azuread_roles_msi" {
  source   = "./azuread/roles"
  for_each = try(local.azuread.azuread_roles.managed_identities, {})

  object_id     = module.managed_identities[each.key].principal_id
  azuread_roles = each.value.roles
}

module "azuread_roles_sql_mi" {
  source   = "./azuread/roles"
  for_each = try(local.azuread.azuread_roles.mssql_managed_instances, {})

  object_id     = module.mssql_managed_instances[each.key].principal_id
  azuread_roles = each.value.roles
}

module "azuread_roles_sql_mi_secondary" {
  source   = "./azuread/roles"
  for_each = try(local.azuread.azuread_roles.mssql_managed_instances_secondary, {})

  object_id     = module.mssql_managed_instances_secondary[each.key].principal_id
  azuread_roles = each.value.roles
}

module "azuread_roles_mssql_server" {
  source   = "./azuread/roles"
  for_each = try(local.azuread.azuread_roles.mssql_servers, {})

  object_id     = module.mssql_servers[each.key].rbac_id
  azuread_roles = each.value.roles
}
