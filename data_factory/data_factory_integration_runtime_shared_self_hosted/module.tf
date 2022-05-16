resource "azurecaf_name" "dfirsh" {
  name          = var.settings.name
  resource_type = "azurerm_data_factory" #"azurerm_data_factory_integration_runtime_self_hosted"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_role_assignment" "target" {
  scope                = var.shared_runtime_data_factory_id
  role_definition_name = "Contributor"
  principal_id         = var.data_factory_mi_id
}

resource "time_sleep" "delay" {
  depends_on      = [azurerm_role_assignment.target]
  create_duration = "180s"
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "dfirsh" {
  depends_on = [
    azurerm_role_assignment.target
  ]

  data_factory_id = var.data_factory_id
  name            = azurecaf_name.dfirsh.result
  description     = try(var.settings.description, null)

  dynamic "rbac_authorization" {
    for_each = try(var.shared_runtime_resource_id, null) == null ? [] : [1]
    content {
      resource_id = var.shared_runtime_resource_id
    }
  }
}
