/*
resource "azurerm_role_assignment" "target" {
  for_each             = try(var.settings.host_data_factory, null) == null ? toset([]) : toset(["enabled"])
  scope                = try(can(var.settings.host_data_factory.resource_id) ? var.settings.host_data_factory.resource_id : var.remote_objects.data_factory[var.settings.host_data_factory.key].id, null)
  role_definition_name = "Contributor"
  principal_id         = can(var.settings.data_factory.principal_id) ? var.settings.data_factory.principal_id : try(var.remote_objects.data_factory[var.settings.data_factory.key].identity[0].principal_id, null)
}
*/

resource "azurecaf_name" "dfirsh" {
  name          = var.settings.name
  resource_type = "azurerm_data_factory" #"azurerm_data_factory_integration_runtime_self_hosted"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "dfirssh" {

  data_factory_id = var.data_factory_id
  name            = azurecaf_name.dfirsh.result
  description     = try(var.settings.description, null)

  dynamic "rbac_authorization" {
    for_each = try(var.settings.host_data_factory, null) == null ? [] : [1]
    content {
      resource_id = try(var.host_runtime_resource_id, null)
    }
  }

}
