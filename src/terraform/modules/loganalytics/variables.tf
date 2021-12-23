variable "tags" {
  description = "List of tags to be applied to all resources"
}
variable "rg_name" {
  type        = string
  description = "The name of the RG to host resources"
}

variable "ws_name" {
  type        = string
  description = "The name of the log analytics workspace to be created"
}