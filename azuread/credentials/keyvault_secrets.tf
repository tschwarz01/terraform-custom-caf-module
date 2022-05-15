
resource "azurerm_key_vault_secret" "client_id" {
  for_each = try(var.settings.keyvaults, {})

  name         = format("%s-client-id", each.value.secret_prefix)
  key_vault_id = try(var.keyvaults[each.key].id, null)

  value = coalesce(
    try(var.resources.application.application_id, null)
  )
}

resource "azurerm_key_vault_secret" "tenant_id" {
  for_each     = try(var.settings.keyvaults, {})
  name         = format("%s-tenant-id", each.value.secret_prefix)
  value        = try(each.value.tenant_id, var.client_config.tenant_id)
  key_vault_id = try(var.keyvaults[each.key].id, null)
}

