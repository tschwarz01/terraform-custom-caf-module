resource "azurecaf_name" "pnetlk" {
  name          = var.name
  resource_type = "azurerm_private_dns_zone_virtual_network_link"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}


resource "azapi_resource" "virtualNetworkLinks" {
  type      = "Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01"
  location  = "global"
  name      = azurecaf_name.pnetlk.result
  parent_id = var.private_dns_zone_id

  body = jsonencode({
    properties = {
      registrationEnabled = try(var.registration_enabled, false)
      virtualNetwork = {
        id = try(var.virtual_network_id, null)
      }
    }
  })

  tags = local.tags
}
