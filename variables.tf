

variable "region" {
  description = "Civo region"
  type        = string
  default     = "nyc1"
}

variable "disk_image" {
  description = "Civo disk image UUID"
  type        = string
}
