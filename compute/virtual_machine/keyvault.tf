locals {
  keyvault = local.create_sshkeys || local.os_type == "windows" ? try(var.keyvaults[var.settings.keyvault_key]) : null
}
