// Creates the networks virtual network, the subnets and associated NSG, with a special section for AzureFirewallSubnet
resource "azurecaf_name" "caf_name_vnet" {

  name          = var.settings.vnet.name
  resource_type = "azurerm_virtual_network"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_virtual_network" "vnet" {
  name                = azurecaf_name.caf_name_vnet.result
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.settings.vnet.address_space
  tags                = local.tags

  dns_servers = coalesce(
    try(lookup(var.settings.vnet, "dns_servers", null)),
    try(local.dns_servers_process, null)
  )

  /*
  dynamic "ddos_protection_plan" {
    for_each = var.ddos_id != "" || can(var.global_settings["ddos_protection_plan_id"]) ? [1] : []

    content {
      id     = var.ddos_id != "" ? var.ddos_id : var.global_settings["ddos_protection_plan_id"]
      enable = true
    }
  }
  */
}

locals {

  subnets = {
    for key, val in var.settings.subnets : key => val if val.should_create == true
  }
  special_subnets = {
    for key, val in var.settings.special_subnets : key => val if val.should_create == true
  }
}

module "special_subnets" {
  source = "./subnet"

  for_each = {
    for key, value in try(local.special_subnets, {}) : key => value
  }
  #for_each                                       = lookup(var.settings, "specialsubnets", {})
  name                                           = each.value.name
  global_settings                                = var.global_settings
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = lookup(each.value, "cidr", [])
  service_endpoints                              = lookup(each.value, "service_endpoints", [])
  enforce_private_link_endpoint_network_policies = lookup(each.value, "enforce_private_link_endpoint_network_policies", false)
  enforce_private_link_service_network_policies  = lookup(each.value, "enforce_private_link_service_network_policies", false)
  settings                                       = each.value
}

module "subnets" {
  source = "./subnet"

  for_each = {
    for key, value in try(local.subnets, {}) : key => value
  }
  #for_each                                       = lookup(var.settings, "subnets", {})
  name                                           = each.value.name
  global_settings                                = var.global_settings
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = lookup(each.value, "cidr", [])
  service_endpoints                              = lookup(each.value, "service_endpoints", [])
  enforce_private_link_endpoint_network_policies = lookup(each.value, "enforce_private_link_endpoint_network_policies", false)
  enforce_private_link_service_network_policies  = lookup(each.value, "enforce_private_link_service_network_policies", false)
  settings                                       = each.value
}



locals {
  dns_servers_process = [
    for obj in try(var.settings.vnet.dns_servers_keys, {}) : #o.ip
    coalesce(
      try(var.remote_dns[obj.resource_type][obj.lz_key][obj.key].virtual_hub[obj.interface_index].private_ip_address, null),
      try(var.remote_dns[obj.resource_type][obj.lz_key][obj.key].virtual_hub.0.private_ip_address, null),
      try(var.remote_dns[obj.resource_type][obj.lz_key][obj.key].ip_configuration[obj.interface_index].private_ip_address, null),
      try(var.remote_dns[obj.resource_type][obj.lz_key][obj.key].ip_configuration.0.private_ip_address, null),
      null
    )
    # for ip_key, resouce_ip in var.settings.vnet.dns_servers_keys: [
    #  resouce_ip.ip
    # ]
  ]
}
