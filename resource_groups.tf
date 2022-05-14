module "resource_groups" {
  source = "./resource_group"
  for_each = {
    for key, value in try(local.deploy_resource_groups, {}) : key => value
  }

  resource_group_name  = each.value.name
  settings             = each.value
  global_settings      = local.global_settings
  tags                 = merge(lookup(each.value, "tags", {}), var.common_module_params.tags)
  common_module_params = var.common_module_params
}

module "resource_group_reused" {
  depends_on = [module.resource_groups]
  source     = "./resource_group_reused"
  for_each = {
    for key, value in try(var.resource_groups, {}) : key => value
    if try(value.reuse, false) == true
  }

  settings = each.value
}

locals {
  resource_groups = merge(module.resource_groups, module.resource_group_reused)
}

output "resource_groups" {
  value = local.resource_groups
}
