#
# Azure Active Directory Users
#

module "azuread_users" {
  source     = "./azuread/users"
  depends_on = [module.keyvault_access_policies]
  for_each   = local.azuread.azuread_users

  client_config   = local.client_config
  global_settings = local.global_settings
  keyvaults       = local.combined_objects_keyvaults
  settings        = each.value
}

output "azuread_users" {
  value = module.azuread_users

}
