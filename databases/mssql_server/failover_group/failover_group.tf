resource "azurecaf_name" "failover_group" {

  name          = var.settings.name
  resource_type = "azurerm_mssql_server" //TODO: add support for sql failover group
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
}

resource "azurerm_mssql_failover_group" "failover_group" {
  name                                      = azurecaf_name.failover_group.result
  server_id                                 = var.primary_server_id
  server_name                               = var.primary_server_name
  databases                                 = local.databases
  readonly_endpoint_failover_policy_enabled = try(var.settings.readonly_endpoint_failover_policy_enabled, false)
  tags                                      = local.tags

  partner_server {
    id = var.secondary_server_id
  }

  read_write_endpoint_failover_policy {
    mode          = var.read_write_endpoint_failover_policy_mode
    grace_minutes = var.read_write_endpoint_failover_policy_grace_minutes
  }
}
