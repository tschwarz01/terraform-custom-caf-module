variable "virtual_machine_scale_set_id" {}
variable "settings" {}
variable "extension" {}
variable "extension_name" {}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
}

variable "storage_accounts" {
  default = {}
}
variable "keyvault_id" {
  default = null
}
variable "keyvaults" {
  default = {}
}
variable "virtual_machine_scale_set_os_type" {
  default = {}
}

variable "integration_runtimes" {
  default = {}
}

variable "log_analytics_workspaces" {
  default = {}
}

variable "managed_identities" {
  default = {}
}

variable "fileuris" {

}

variable "commandtoexecute" {

}
