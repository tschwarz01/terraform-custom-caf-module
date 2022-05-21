output "resources" {
  value = {
    resource_groups = merge(try(local.combined_objects_resource_groups, {}), {})
    log_analytics   = merge(try(local.combined_objects_log_analytics, {}), {})
  }
}
