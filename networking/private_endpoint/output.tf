output "id" {
  value = azurerm_private_endpoint.pep.id
}

output "name" {
  value = azurerm_private_endpoint.pep.name
}

output "private_dns_zone_group" {
  value = azurerm_private_endpoint.pep.private_dns_zone_group

}

output "private_dns_zone_configs" {
  value = azurerm_private_endpoint.pep.private_dns_zone_configs

}
