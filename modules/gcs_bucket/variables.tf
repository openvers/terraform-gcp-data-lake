## ---------------------------------------------------------------------------------------------------------------------
## MODULE PARAMETERS
## These variables are expected to be passed in by the operator
## ---------------------------------------------------------------------------------------------------------------------

variable "bucket_name" {
  type        = string
  description = "GCS Storage Bucket Name"
}

variable "google_kms_crypto_key_id" {
  type        = string
  description = "ID of the Google Cloud KMS Crypto Key for Customer Managed Encryption"
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

variable "storage_lifecycle_archival_days" {
  type        = number
  description = "Number of days after which objects should be archived"
  default     = 30
}

variable "storage_lifecycle_deletion_days" {
  type        = number
  description = "Number of days after which objects should be deleted"
  default     = 365
}
