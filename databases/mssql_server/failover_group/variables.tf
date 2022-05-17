variable "global_settings" {
  description = "Global settings object (see module README.md)"
}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
}
variable "settings" {}
variable "base_tags" {

}

variable "primary_server_id" {
  description = "(Required) The id of the primary azure sql server."
  type        = string
}
variable "secondary_server_id" {
  description = "(Required) The id of the secondary azure sql server."
  type        = string
}
variable "primary_server_name" {
  description = "The name of the primary azure sql server"
}

variable "databases" {
  description = "A set of database names to include in the failover group."
}

variable "read_write_endpoint_failover_policy_mode" {
  type = string
}

variable "read_write_endpoint_failover_policy_grace_minutes" {
  type = number
}
