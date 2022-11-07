variable "storage_name" {
  type        = string
  description = "The name of the Storage Account"
  default     = "logws"
}

variable "tags" {
  description = "List of tags to be applied to all resources"
}

variable "location" {
}

variable "resource_group_name" {
}

variable "home_ip" {
}