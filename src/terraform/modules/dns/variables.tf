variable "tags" {
  description = "List of tags to be applied to all resources"
}
variable "resource_group_name" {
  type        = string
  description = "The name of the RG to host zones"
}

variable "zone_name" {
  type        = string
  description = "The name of the zone"
}

variable "records"{
    
}
