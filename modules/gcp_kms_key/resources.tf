terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      configuration_aliases = [
        google.auth_session,
      ]
    }
  }
}

##----------------------------------------------------------------------------------------------------------------------
## GOOGLE KMS KEY RING RESOURCE
##
## Google Key Management Service (KMS) key ring resource
## Parameters:
## - kms_key_ring_name: Name of the KMS key ring
## - kms_key_ring_location: Location of the KMS key ring
##----------------------------------------------------------------------------------------------------------------------
resource "google_kms_key_ring" "this" {
  provider = google.auth_session

  name     = var.kms_key_ring_name
  location = var.kms_key_ring_location
}

##----------------------------------------------------------------------------------------------------------------------
## GOOGLE KMS CRYPTO KEY RESOURCE
##
## Google Key Management Service (KMS) crypto key resource
## Parameters:
## - kms_key_name: Name of the KMS crypto key
## - kms_key_ring_id: ID of the KMS key ring
## - kms_key_rotation_period: Rotation period of the KMS crypto key
##----------------------------------------------------------------------------------------------------------------------
resource "google_kms_crypto_key" "this" {
  provider = google.auth_session

  name            = var.kms_key_name
  key_ring        = google_kms_key_ring.this.id
  rotation_period = var.kms_key_rotation_period
}
