variable "tags" {
  description = "List of tags to be applied to all resources"
}
variable "resources_rg_name" {
  type        = string
  description = "The name of the RG to host resources"
  default     = "resources"
}

variable "resources_rg_location" {
  type        = string
  description = "The location of the RG to host resources"
  default     = "westeurope"

}

variable "monitoring_rg_location" {
  type        = string
  description = "The location of the RG to host resources"
  default     = "westeurope"
}

variable "monitoring_rg_name" {
  type        = string
  description = "The location of the RG to host resources"
  default     = "monitoring"
}

variable "logws_name" {
  type        = string
  description = "The name of the Log Analytics workspace"
  default     = "logws"
}

variable "monitoring_vm" {
  type        = string
  description = "Deploy monitoring VM"
  default     = true
}

variable "aks1" {
  type        = string
  description = "Deploy monitoring VM"
  default     = true
}
variable "pubkey" {
  type        = string
  description = "SSH Public key"
}

variable "prometheus_disk_size" {
  type        = string
  description = "prometheus_disk_size"
}

variable "loki_disk_size" {
  type        = string
  description = "loki_disk_size"
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

variable "home_prefix" {
  description = "My home prefix"
}

variable "storage_name" {
  type        = string
  description = "Main storage account name"
}
