
resource "azurerm_key_vault_secret" "client_id" {
  for_each = try(var.settings.keyvaults, {})

  name         = format("%s-client-id", each.value.secret_prefix)
  value        = azuread_application.app.application_id
  key_vault_id = try(each.value.lz_key, null) == null ? var.keyvaults[each.key].id : var.keyvaults[each.key].id

  lifecycle {
    ignore_changes = [
      value
    ]
  }

}

resource "azurerm_key_vault_secret" "client_secret" {
  for_each        = try(var.settings.keyvaults, {})
  name            = format("%s-client-secret", each.value.secret_prefix)
  value           = azuread_service_principal_password.pwd.value
  key_vault_id    = try(var.keyvaults[each.key].id, null)
  expiration_date = timeadd(time_rotating.pwd.id, format("%sh", local.password_policy.expire_in_days * 24))
}

resource "azurerm_key_vault_secret" "tenant_id" {
  for_each     = try(var.settings.keyvaults, {})
  name         = format("%s-tenant-id", each.value.secret_prefix)
  value        = var.client_config.tenant_id
  key_vault_id = try(var.keyvaults[each.key].id, null)
}
