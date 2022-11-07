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