## ---------------------------------------------------------------------------------------------------------------------
## MODULE PARAMETERS
## These variables are expected to be passed in by the operator
## ---------------------------------------------------------------------------------------------------------------------

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

variable "kms_key_ring_location" {
  type        = string
  description = "Google KMS key ring location"
  default     = "us-east1"
}

variable "kms_key_rotation_period" {
  type        = string
  description = "Google KMS key rotation period"
  default     = "86400s"
}
