output "resources" {
  value = {
    resource_groups             = merge(try(local.combined_objects_resource_groups, {}), {})
    diagnostic_storage_accounts = merge(try(local.combined_objects_diagnostic_storage_accounts, {}), {})
    diagnostic_log_analytics    = merge(try(local.combined_objects_diagnostic_log_analytics, {}), {})
    private_dns                 = merge(try(local.combined_objects_private_dns, {}), {})
  }
}
