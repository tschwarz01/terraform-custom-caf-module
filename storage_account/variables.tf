variable "global_settings" {
  description = "Global settings object (see module README.md)"
}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
}
variable "storage_account" {}
variable "resource_group_name" {
  description = "(Required) The name of the resource group where to create the resource."
  type        = string
}
variable "location" {
  description = "(Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created."
  type        = string
}
variable "resource_groups" {
  default = {}
}
variable "base_tags" {
  default = {}
}
variable "recovery_vaults" {
  default = {}
}
variable "remote_objects" {
  default = {
    private_endpoints = {}
  }
}
variable "vnets" {
  default = {}
}
variable "managed_identities" {
  default = {}
}
variable "private_endpoints" {
  default = {}
}
variable "private_dns" {
  default = {}
}
