module "shared_image_galleries" {
  source   = "./shared_image_gallery/image_galleries"
  for_each = try(local.shared_services.shared_image_galleries, {})

  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group_key, each.value.resource_group.key)].name
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].location
  diagnostics         = local.diagnostics
  client_config       = local.client_config
  global_settings     = local.global_settings
  settings            = each.value
  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}

  depends_on = [
    module.keyvaults,
  ]
}

/*
module "image_definitions" {
  source   = "./modules/shared_image_gallery/image_definitions"
  for_each = try(local.shared_services.image_definitions, {})

  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
  diagnostics         = local.diagnostics
  client_config       = local.client_config
  global_settings     = local.global_settings
  gallery_name        = module.shared_image_galleries[each.value.gallery_key].name
  settings            = each.value
  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}

}

output "image_definitions" {
  value = module.image_definitions
}

module "packer_service_principal" {
  source   = "./modules/shared_image_gallery/packer_service_principal"
  for_each = try(local.shared_services.packer_service_principal, {})

  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
  client_config       = local.client_config
  global_settings     = local.global_settings
  subscription        = data.azurerm_subscription.primary.subscription_id
  tenant_id           = data.azurerm_client_config.current.tenant_id
  gallery_name        = module.shared_image_galleries[each.value.shared_image_gallery_destination.gallery_key].name
  image_name          = module.image_definitions[each.value.shared_image_gallery_destination.image_key].name
  key_vault_id        = lookup(each.value, "keyvault_key") == null ? null : module.keyvaults[each.value.keyvault_key].id
  settings            = each.value
  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}

  depends_on = [
    module.shared_image_galleries,
    module.image_definitions,
    azurerm_role_assignment.for,
  ]
}
*/

/*
module "packer_build" {
  source   = "./modules/shared_image_gallery/packer_build"
  for_each = try(local.shared_services.packer_build, {})

  resource_group_name       = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
  location                  = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
  build_resource_group_name = try(local.resource_groups[each.value.build_resource_group_key].name, local.resource_groups[each.value.resource_group_key].name) #build in separate or same rg
  client_config             = local.client_config
  global_settings           = local.global_settings
  subscription              = data.azurerm_subscription.primary.subscription_id
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  gallery_name              = module.shared_image_galleries[each.value.shared_image_gallery_destination.gallery_key].name
  image_name                = module.image_definitions[each.value.shared_image_gallery_destination.image_key].name
  key_vault_id              = lookup(each.value, "keyvault_key") == null ? null : module.keyvaults[each.value.keyvault_key].id
  managed_identities        = local.combined_objects_managed_identities
  vnet_name                 = try(try(local.combined_objects_networking[each.value.vnet_key].name, local.combined_objects_networking[local.client_config.landingzone_key][each.value.vnet_key].name), "")
  subnet_name               = try(lookup(each.value, "lz_key", null) == null ? local.combined_objects_networking.subnets[each.value.subnet_key].name : local.combined_objects_networking[each.value.lz_key][each.value.vnet_key].subnets[each.value.subnet_key].name, "")
  settings                  = each.value
  base_tags                 = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  depends_on = [
    module.shared_image_galleries,
    module.image_definitions,
    azurerm_role_assignment.for,
  ]
}
*/
