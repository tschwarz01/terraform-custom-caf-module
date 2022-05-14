locals {
  keyvault = local.create_sshkeys || local.os_type == "windows" ? try(var.keyvaults[var.settings.keyvault_key], var.keyvaults[var.settings.keyvault.key]) : null
}
