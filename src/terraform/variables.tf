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

variable "pubkey" {
  type        = string
  description = "SSH Public key"
}

variable "storage_name" {
  type        = string
  description = "The name of the storage account"
  default     = "mainstorage"
}

variable "acr_name" {
  type        = string
  description = "ACR name"
}

variable "acr_sku" {
  type        = string
  description = "ACR SKU"
  default     = "Standard"
}

# variable "acr_alternate_location" {
#   type        = string
#   description = "ACR alternate location"
#   default     = "West US 2"
# }
