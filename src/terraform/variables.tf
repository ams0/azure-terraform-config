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