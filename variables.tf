variable "resource_group_location" {
  default = "	westeurope"
  description   = "Location of the resource group."
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "vault_username" {
  type = string
}

variable "vault_password" {
  type = string
}