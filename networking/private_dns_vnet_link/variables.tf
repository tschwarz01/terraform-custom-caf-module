variable "global_settings" {
  description = "Global settings object (see module README.md)"
}

variable "virtual_network_id" {
}

variable "private_dns" {
  default = {}
}

variable "name" {
}

variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
}
variable "tags" {
  default = {}
}


variable "registration_enabled" {
  type    = bool
  default = false
}


variable "private_dns_zone_id" {
  type = string

}

