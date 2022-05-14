resource "random_string" "prefix" {
  count   = try(var.global_settings.prefix, null) == null ? 1 : 0
  length  = 4
  special = false
  upper   = false
  number  = false
}

data "azurerm_subscription" "primary" {}
data "azurerm_client_config" "current" {}
data "azuread_service_principal" "logged_in_app" {
  count          = var.logged_aad_app_objectId == null ? 0 : 1
  application_id = data.azurerm_client_config.current.client_id
}


locals {

  object_id = coalesce(var.logged_user_objectId, var.logged_aad_app_objectId, try(data.azurerm_client_config.current.object_id, null), try(data.azuread_service_principal.logged_in_app.0.object_id, null))

  global_settings = merge({
    default_region     = try(var.global_settings.default_region, "region1")
    environment        = try(var.global_settings.environment, var.environment)
    inherit_tags       = try(var.global_settings.inherit_tags, false)
    passthrough        = try(var.global_settings.passthrough, false)
    prefix             = try(var.global_settings.prefix, null)
    prefix_with_hyphen = try(var.global_settings.prefix_with_hyphen, format("%s-", try(var.global_settings.prefix, try(var.global_settings.prefixes[0], random_string.prefix.0.result))))
    prefixes           = try(var.global_settings.prefix, null) == "" ? null : try([var.global_settings.prefix], try(var.global_settings.prefixes, [random_string.prefix.0.result]))
    random_length      = try(var.global_settings.random_length, 0)
    regions            = try(var.global_settings.regions, null)
    tags               = try(var.global_settings.tags, null)
    use_slug           = try(var.global_settings.use_slug, true)
  }, var.global_settings)

}

locals {
  deploy_resource_groups = {
    for key, val in var.resource_groups : key => val if val.should_create == true
  }
}



locals {

  purview = {
    purview_accounts = try(var.purview.purview_accounts, {})
  }

  security = {
    disk_encryption_sets     = try(var.security.disk_encryption_sets, {})
    dynamic_keyvault_secrets = try(var.security.dynamic_keyvault_secrets, {})
    #keyvault_certificate_issuers        = try(var.security.keyvault_certificate_issuers, {})
    #keyvault_certificate_requests       = try(var.security.keyvault_certificate_requests, {})
    #keyvault_certificates               = try(var.security.keyvault_certificates, {})
    keyvault_keys = try(var.security.keyvault_keys, {})
    #lighthouse_definitions              = try(var.security.lighthouse_definitions, {})
    #sentinel_automation_rules           = try(var.security.sentinel_automation_rules, {})
    #sentinel_watchlists                 = try(var.security.sentinel_watchlists, {})
    #sentinel_watchlist_items            = try(var.security.sentinel_watchlist_items, {})
    #sentinel_ar_fusions                 = try(var.security.sentinel_ar_fusions, {})
    #sentinel_ar_ml_behavior_analytics   = try(var.security.sentinel_ar_ml_behavior_analytics, {})
    #sentinel_ar_ms_security_incidents   = try(var.security.sentinel_ar_ms_security_incidents, {})
    #sentinel_ar_scheduled               = try(var.security.sentinel_ar_scheduled, {})
    #sentinel_dc_aad                     = try(var.security.sentinel_dc_aad, {})
    #sentinel_dc_app_security            = try(var.security.sentinel_dc_app_security, {})
    #sentinel_dc_aws                     = try(var.security.sentinel_dc_aws, {})
    #sentinel_dc_azure_threat_protection = try(var.security.sentinel_dc_azure_threat_protection, {})
    #sentinel_dc_ms_threat_protection    = try(var.security.sentinel_dc_ms_threat_protection, {})
    #sentinel_dc_office_365              = try(var.security.sentinel_dc_office_365, {})
    #sentinel_dc_security_center         = try(var.security.sentinel_dc_security_center, {})
    #sentinel_dc_threat_intelligence     = try(var.security.sentinel_dc_threat_intelligence, {})
  }

  shared_services = {
    automations                    = try(var.shared_services.automations, {})
    consumption_budgets            = try(var.shared_services.consumption_budgets, {})
    image_definitions              = try(var.shared_services.image_definitions, {})
    log_analytics_storage_insights = try(var.shared_services.log_analytics_storage_insights, {})
    monitor_autoscale_settings     = try(var.shared_services.monitor_autoscale_settings, {})
    monitor_action_groups          = try(var.shared_services.monitor_action_groups, {})
    monitoring                     = try(var.shared_services.monitoring, {})
    monitor_metric_alert           = try(var.shared_services.monitor_metric_alert, {})
    monitor_activity_log_alert     = try(var.shared_services.monitor_activity_log_alert, {})
    packer_service_principal       = try(var.shared_services.packer_service_principal, {})
    packer_build                   = try(var.shared_services.packer_build, {})
    recovery_vaults                = try(var.shared_services.recovery_vaults, {})
    shared_image_galleries         = try(var.shared_services.shared_image_galleries, {})
  }

  data_factory = {
    data_factory                                 = try(var.data_factory.data_factory, {})
    data_factory_integration_runtime_self_hosted = try(var.data_factory.data_factory_integration_runtime_self_hosted, {})
  }
}

locals {
  networking = {
    application_gateway_applications                        = try(var.networking.application_gateway_applications, {})
    application_gateway_applications_v1                     = try(var.networking.application_gateway_applications_v1, {})
    application_gateway_platforms                           = try(var.networking.application_gateway_platforms, {})
    application_gateway_waf_policies                        = try(var.networking.application_gateway_waf_policies, {})
    application_gateways                                    = try(var.networking.application_gateways, {})
    application_security_groups                             = try(var.networking.application_security_groups, {})
    azurerm_firewall_application_rule_collection_definition = try(var.networking.azurerm_firewall_application_rule_collection_definition, {})
    azurerm_firewall_nat_rule_collection_definition         = try(var.networking.azurerm_firewall_nat_rule_collection_definition, {})
    azurerm_firewall_network_rule_collection_definition     = try(var.networking.azurerm_firewall_network_rule_collection_definition, {})
    azurerm_firewall_policies                               = try(var.networking.azurerm_firewall_policies, {})
    azurerm_firewall_policy_rule_collection_groups          = try(var.networking.azurerm_firewall_policy_rule_collection_groups, {})
    azurerm_firewalls                                       = try(var.networking.azurerm_firewalls, {})
    azurerm_routes                                          = try(var.networking.azurerm_routes, {})
    cdn_endpoint                                            = try(var.networking.cdn_endpoint, {})
    cdn_profile                                             = try(var.networking.cdn_profile, {})
    ddos_services                                           = try(var.networking.ddos_services, {})
    dns_zone_records                                        = try(var.networking.dns_zone_records, {})
    dns_zones                                               = try(var.networking.dns_zones, {})
    domain_name_registrations                               = try(var.networking.domain_name_registrations, {})
    express_route_circuit_authorizations                    = try(var.networking.express_route_circuit_authorizations, {})
    express_route_circuit_peerings                          = try(var.networking.express_route_circuit_peerings, {})
    express_route_circuits                                  = try(var.networking.express_route_circuits, {})
    express_route_connections                               = try(var.networking.express_route_connections, {})
    front_door_waf_policies                                 = try(var.networking.front_door_waf_policies, {})
    front_doors                                             = try(var.networking.front_doors, {})
    frontdoor_custom_https_configuration                    = try(var.networking.frontdoor_custom_https_configuration, {})
    frontdoor_rules_engine                                  = try(var.networking.frontdoor_rules_engine, {})
    ip_groups                                               = try(var.networking.ip_groups, {})
    lb                                                      = try(var.networking.lb, {})
    lb_backend_address_pool                                 = try(var.networking.lb_backend_address_pool, {})
    lb_backend_address_pool_address                         = try(var.networking.lb_backend_address_pool_address, {})
    lb_nat_pool                                             = try(var.networking.lb_nat_pool, {})
    lb_nat_rule                                             = try(var.networking.lb_nat_rule, {})
    lb_outbound_rule                                        = try(var.networking.lb_outbound_rule, {})
    lb_probe                                                = try(var.networking.lb_probe, {})
    lb_rule                                                 = try(var.networking.lb_rule, {})
    load_balancers                                          = try(var.networking.load_balancers, {})
    local_network_gateways                                  = try(var.networking.local_network_gateways, {})
    nat_gateways                                            = try(var.networking.nat_gateways, {})
    network_interface_backend_address_pool_association      = try(var.networking.network_interface_backend_address_pool_association, {})
    network_profiles                                        = try(var.networking.network_profiles, {})
    network_security_group_definition                       = try(var.networking.network_security_group_definition, {})
    network_watchers                                        = try(var.networking.network_watchers, {})
    private_dns                                             = try(var.networking.private_dns, {})
    private_dns_vnet_links                                  = try(var.networking.private_dns_vnet_links, {})
    public_ip_addresses                                     = try(var.networking.public_ip_addresses, {})
    public_ip_prefixes                                      = try(var.networking.public_ip_prefixes, {})
    route_tables                                            = try(var.networking.route_tables, {})
    synapse_privatelink_hubs                                = try(var.networking.synapse_privatelink_hubs, {})
    vhub_peerings                                           = try(var.networking.vhub_peerings, {})
    virtual_hub_connections                                 = try(var.networking.virtual_hub_connections, {})
    virtual_hub_er_gateway_connections                      = try(var.networking.virtual_hub_er_gateway_connections, {})
    virtual_hub_route_table_routes                          = try(var.networking.virtual_hub_route_table_routes, {})
    virtual_hub_route_tables                                = try(var.networking.virtual_hub_route_tables, {})
    virtual_hubs                                            = try(var.networking.virtual_hubs, {})
    virtual_network_gateway_connections                     = try(var.networking.virtual_network_gateway_connections, {})
    virtual_network_gateways                                = try(var.networking.virtual_network_gateways, {})
    virtual_subnets                                         = try(var.networking.virtual_subnets, {})
    virtual_wans                                            = try(var.networking.virtual_wans, {})
    vnet_peerings                                           = try(var.networking.vnet_peerings, {})
    vnet_peerings_v1                                        = try(var.networking.vnet_peerings_v1, {})
    vnets                                                   = try(var.networking.vnets, {})
    vpn_gateway_connections                                 = try(var.networking.vpn_gateway_connections, {})
    vpn_sites                                               = try(var.networking.vpn_sites, {})
  }

  compute = {
    bastion_hosts                                         = try(var.compute.bastion_hosts, {})
    container_groups                                      = try(var.compute.container_groups, {})
    azure_container_registries                            = try(var.compute.azure_container_registries, {})
    virtual_machines                                      = try(var.compute.virtual_machines, {})
    virtual_machine_scale_sets                            = try(var.compute.virtual_machine_scale_sets, {})
    vmss_extensions_custom_script_adf_integration_runtime = try(var.compute.vmss_extensions_custom_script_adf_integration_runtime, {})
  }

  database = {
    app_config                         = try(var.database.app_config, {})
    cosmos_dbs                         = try(var.database.cosmos_dbs, {})
    cosmosdb_sql_databases             = try(var.database.cosmosdb_sql_databases, {})
    databricks_workspaces              = try(var.database.databricks_workspaces, {})
    machine_learning_workspaces        = try(var.database.machine_learning_workspaces, {})
    mssql_databases                    = try(var.database.mssql_databases, {})
    mssql_elastic_pools                = try(var.database.mssql_elastic_pools, {})
    mssql_failover_groups              = try(var.database.mssql_failover_groups, {})
    mssql_managed_databases            = try(var.database.mssql_managed_databases, {})
    mssql_managed_databases_backup_ltr = try(var.database.mssql_managed_databases_backup_ltr, {})
    mssql_managed_databases_restore    = try(var.database.mssql_managed_databases_restore, {})
    mssql_managed_instances            = try(var.database.mssql_managed_instances, {})
    mssql_managed_instances_secondary  = try(var.database.mssql_managed_instances_secondary, {})
    mssql_mi_administrators            = try(var.database.mssql_mi_administrators, {})
    mssql_mi_failover_groups           = try(var.database.mssql_mi_failover_groups, {})
    mssql_mi_secondary_tdes            = try(var.database.mssql_mi_secondary_tdes, {})
    mssql_mi_tdes                      = try(var.database.mssql_mi_tdes, {})
    mssql_servers                      = try(var.database.mssql_servers, {})
    mysql_databases                    = try(var.database.mysql_databases, {})
    mysql_servers                      = try(var.database.mysql_servers, {})
    postgresql_flexible_servers        = try(var.database.postgresql_flexible_servers, {})
    postgresql_servers                 = try(var.database.postgresql_servers, {})
    synapse_workspaces                 = try(var.database.synapse_workspaces, {})
  }

  storage = {
    netapp_accounts        = try(var.storage.netapp_accounts, {})
    storage_account_blobs  = try(var.storage.storage_account_blobs, {})
    storage_account_queues = try(var.storage.storage_account_queues, {})
    storage_containers     = try(var.storage.storage_containers, {})
  }
}

locals {

  client_config = var.client_config == {} ? {
    client_id = data.azurerm_client_config.current.client_id
    #landingzone_key         = var.current_landingzone_key
    logged_aad_app_objectId = local.object_id
    logged_user_objectId    = local.object_id
    object_id               = local.object_id
    subscription_id         = data.azurerm_client_config.current.subscription_id
    tenant_id               = data.azurerm_client_config.current.tenant_id
  } : map(var.client_config)

}
