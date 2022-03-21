variable "tags" {
  type        = map(any)
  description = "tags"
}

variable "environment" {
  type        = string
  description = "The environment name"
}

variable "app_name" {
  type        = string
  description = "Application name of the project"
  default     = "aks"
}

variable "location" {
  type        = string
  description = "The Location for Infra centre"
  default     = "North Europe"
}

variable "resource_group_name" {
  type        = string
  description = "The Resource group name"
}

variable "virtual_network_subnet_ids" {
  description = "A list of subnets ids"
}


variable "storages" {
  type = any
}