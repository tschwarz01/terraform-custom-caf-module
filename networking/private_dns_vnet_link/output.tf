output "ids" {
  value = azapi_resource.virtualNetworkLinks
  #value = azurerm_private_dns_zone_virtual_network_link.vnet_links.*
}
