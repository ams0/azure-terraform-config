variable "logws_name" {
  type        = string
  description = "The name of the Log Analytics workspace"
  default     = "logws"
}

variable "tags" {
  description = "List of tags to be applied to all resources"
}

variable "location" {

}

variable "resource_group_name" {

}
