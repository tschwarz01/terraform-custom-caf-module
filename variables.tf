variable "resource_groups" {
  default = {}
}

variable "global_settings" {
  description = "Global settings object for the current deployment."
  default = {
    passthrough    = false
    random_length  = 4
    default_region = "region1"
    regions = {
      region1 = "southcentralus"
      region2 = "centralus"
    }
  }
}

variable "common_module_params" {
  default = {}
}

variable "environment" {
  description = "Name of the CAF environment."
  type        = string
  default     = "lz"
}

variable "networking" {
  default = {}
}

variable "remote_objects" {
  default = {}
}

variable "client_config" {
  default = {}
}

variable "logged_user_objectId" {
  description = "Used to set access policies based on the value 'logged_in_user'. Can only be used in interactive execution with vscode."
  type        = string
  default     = null
}
variable "logged_aad_app_objectId" {
  description = "Used to set access policies based on the value 'logged_in_aad_app'"
  type        = string
  default     = null
}

## Diagnostics settings
variable "diagnostics_definition" {
  default     = null
  description = "Configuration object - Shared diadgnostics settings that can be used by the services to enable diagnostics."
}

variable "diagnostics_destinations" {
  description = "Configuration object - Describes the destinations for the diagnostics."
  default     = null
}

variable "log_analytics" {
  description = "Configuration object - Log Analytics resources."
  default     = {}
}

variable "diagnostics" {
  description = "Configuration object - Diagnostics object."
  default     = {}
}

# Shared services
variable "shared_services" {
  description = "Configuration object - Shared services resources"
  default = {
    # automations = {}
    # monitoring = {}
    # recovery_vaults = {}
  }
}

## Storage variables
variable "storage_accounts" {
  description = "Configuration object - Storage account resources"
  default     = {}
}
variable "storage" {
  description = "Configuration object - Storage account resources"
  default     = {}
}
variable "diagnostic_storage_accounts" {
  description = "Configuration object - Storage account for diagnostics resources"
  default     = {}
}

variable "keyvaults" {
  description = "Configuration object - Azure Key Vault resources"
  default     = {}
}

variable "keyvault_access_policies" {
  description = "Configuration object - Azure Key Vault policies"
  default     = {}
}

variable "keyvault_access_policies_azuread_apps" {
  description = "Configuration object - Azure Key Vault policy for azure ad applications"
  default     = {}
}


## Security variables
variable "security" {
  description = "Configuration object - security resources"
  default     = {}
}

variable "dynamic_keyvault_secrets" {
  default = {}
}

variable "custom_role_definitions" {
  description = "Configuration object - Custom role definitions"
  default     = {}
}


variable "role_mapping" {
  description = "Configuration object - Role mapping"
  default = {
    built_in_role_mapping = {}
    custom_role_mapping   = {}
  }
}

variable "managed_identities" {
  description = "Configuration object - Azure managed identity resources"
  default     = {}
}

variable "data_factory" {
  description = "Configuration object - Azure Data Factory resources"
  default     = {}
}

variable "data_factory_integration_runtime_self_hosted" {
  default = {}
}

variable "purview" {
  default = {}
}

## Compute variables
variable "compute" {
  description = "Configuration object - Azure compute resources"
  default = {
    virtual_machines = {}
  }
}

variable "vmss_extensions_custom_script_adf_integration_runtime" {
  default = {}
}

variable "database" {
  default = {}
}
