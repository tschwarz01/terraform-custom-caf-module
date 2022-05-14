
resource "azurecaf_name" "plh" {
  name          = var.settings.name
  resource_type = "azurerm_synapse_workspace"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}


resource "azurerm_synapse_private_link_hub" "plh" {
  name                = azurecaf_name.plh.name
  resource_group_name = var.resource_group_name
  location            = var.location
}
