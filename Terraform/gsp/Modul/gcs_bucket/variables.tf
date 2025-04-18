variable "bucket_name" {}

variable "location" {
  default = "europe-north1"
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "uniform_access" {
  type    = bool
  default = true
}

variable "versioning_enabled" {
  type    = bool
  default = false
}

