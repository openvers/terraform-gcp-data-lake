## ---------------------------------------------------------------------------------------------------------------------
## MODULE PARAMETERS
## These variables are expected to be passed in by the operator
## ---------------------------------------------------------------------------------------------------------------------

variable "bronze_bucket_name" {
  description = "The name of the bronze bucket."
  type        = string
}

variable "silver_bucket_name" {
  description = "The name of the silver bucket."
  type        = string
}

variable "gold_bucket_name" {
  description = "The name of the gold bucket."
  type        = string
}

variable "kms_key_ring_name" {
  type        = string
  description = "Google KMS key ring name"
}

variable "kms_key_name" {
  type        = string
  description = "Google KMS key name"
}

## ---------------------------------------------------------------------------------------------------------------------
## OPTIONAL PARAMETERS
## These variables have defaults and may be overridden
## ---------------------------------------------------------------------------------------------------------------------

variable "storage_class" {
  type        = string
  description = "GCS Blob Storage Type"
  default     = "standard"
}

variable "storage_location" {
  type        = string
  description = "GCS Blob Storage Region"
  default     = "us-east1"
}
