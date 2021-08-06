variable "tags" {
  description = "List of tags to be applied to all resources"
}

variable "resource_group_name" {
  description = "Resource group name"
}

variable "location" {
  description = "Resource group location"
}


variable "home_ip" {
  type        = string
  description = "My home IP (set in Terraform Cloud)"
}

variable "home_prefix" {
  description = "My home prefix"
}

variable "subnet_id" {
  type        = string
  description = "Subnet id for vpn gateway"
}
