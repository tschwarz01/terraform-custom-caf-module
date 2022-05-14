resource "azurerm_virtual_machine_scale_set_extension" "custom_script" {
  for_each                     = var.extension_name == "custom_script" ? toset(["enabled"]) : toset([])
  name                         = "custom_script"
  virtual_machine_scale_set_id = var.virtual_machine_scale_set_id
  type                         = local.type
  publisher                    = local.publisher
  type_handler_version         = local.type_handler_version
  auto_upgrade_minor_version   = try(var.extension.auto_upgrade_minor_version, true)
  automatic_upgrade_enabled    = try(var.extension.automatic_upgrade_enabled, null)

  settings = jsonencode(
    {
      "fileUris" : local.fileuris,
      "timestamp" : try(toint(var.extension.timestamp), 12345678)
    }
  )

  protected_settings = jsonencode(local.protected_settings)
}

locals {
  # Managed identity
  identity_type          = try(var.extension.identity_type, "") # userassigned, systemassigned or null
  managed_local_identity = try(var.managed_identities[var.client_config.landingzone_key][var.extension.managed_identity_key].principal_id, "")
  #managed_remote_identity = try(var.managed_identities[var.extension.managed_identity_key].principal_id, "")
  provided_identity = try(var.extension.managed_identity_id, "")
  managed_identity  = try(coalesce(local.managed_local_identity, local.provided_identity), "")

  map_system_assigned = {
    managedIdentity = {}
  }
  map_user_assigned = {
    managedIdentity = {
      objectid = local.managed_identity
    }
  }
  map_command = {
    commandToExecute = try(var.commandtoexecute, "")
  }

  system_assigned_id = local.identity_type == "SystemAssigned" ? local.map_system_assigned : null
  user_assigned_id   = local.identity_type == "UserAssigned" ? local.map_user_assigned : null

  publisher            = var.virtual_machine_scale_set_os_type == "linux" ? "Microsoft.Azure.Extensions" : "Microsoft.Compute"
  type_handler_version = var.virtual_machine_scale_set_os_type == "linux" ? "2.1" : "1.10"
  type                 = var.virtual_machine_scale_set_os_type == "linux" ? "CustomScript" : "CustomScriptExtension"

  protected_settings = merge(local.map_command, local.system_assigned_id, local.user_assigned_id)

  # Fileuris
  fileuris             = local.fileuri_sa_defined == "" ? [local.fileuri_sa_full_path] : var.fileuris
  fileuri_sa_key       = try(var.extension.fileuri_sa_key, "")
  fileuri_sa_path      = try(var.extension.fileuri_sa_path, "")
  fileuri_sa           = local.fileuri_sa_key != "" ? try(var.storage_accounts[var.extension.fileuri_sa_key].primary_blob_endpoint, null) != null : ""
  fileuri_sa_full_path = "${local.fileuri_sa}${local.fileuri_sa_path}"
  fileuri_sa_defined   = try(var.fileuris, "")
}
