output "id" {
  value = azapi_resource.virtualNetworkLinks.id
  #value = azurerm_private_dns_zone_virtual_network_link.vnet_links.*
}
