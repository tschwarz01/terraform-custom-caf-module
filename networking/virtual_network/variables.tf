#variable "client_config" {}
variable "resource_group_name" {
  description = "(Required) Name of the resource group where to create the resource. Changing this forces a new resource to be created. "
  type        = string
}

variable "location" {
  description = "(Required) Specifies the Azure location to deploy the resource. Changing this forces a new resource to be created."
  type        = string
}

variable "tags" {
  description = "(Required) map of tags for the deployment"
}

variable "settings" {
  description = "(Required) configuration object describing the networking configuration, as described in README"
}

variable "global_settings" {
  description = "Global settings object (see module README.md)"
}
variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
}

variable "remote_dns" {
  default = {}
}

variable "network_security_groups" {
  default     = {}
  description = "Network Security Group cretaed with different Resource Group"
}

variable "route_tables" {
  default = {}
}

variable "diagnostics" {
  description = "(Required) Diagnostics object with the definitions and destination services"
}
