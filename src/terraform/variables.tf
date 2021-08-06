variable "tags" {
  description = "List of tags to be applied to all resources"
}
variable "main_rg_name" {
  type        = string
  description = "The name of the RG to host resources"
}

variable "main_rg_location" {
  type        = string
  description = "The location of the RG to host resources"
}
variable "pubkey" {
  type        = string
  description = "SSH Public key"
}

variable "prometheus_disk_size" {
  type        = string
  description = "SSH Public key"
}

variable "vnets" {
  type = list(object({
    vnet_name     = string
    address_space = list(string)
    subnets = list(object({
      name              = string
      prefix            = string
      service_endpoints = list(string)
    }))
  }))
}

variable "home_ip" {
  type        = string
  description = "My home IP (set in Terraform Cloud)"
}

variable "storage_name" {
  type        = string
  description = "Main storage account name"
}
