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
## GOOGLE KMS KEY MODULE
##
## Google Cloud KMS Key Module
##
## Parameters:
## - kms_key_ring_name: Name of the KMS key ring
## - kms_key_name: Name of the KMS key
##----------------------------------------------------------------------------------------------------------------------
module "google_kms_key" {
  source = "./modules/gcp_kms_key"

  kms_key_ring_name = var.kms_key_ring_name
  kms_key_name      = var.kms_key_name

  providers = {
    google.auth_session = google.auth_session
  }
}

##----------------------------------------------------------------------------------------------------------------------
## GOOGLE CLOUD STORAGE BRONZE BUCKET MODULE
##
## Google Cloud Storage Bucket Module
##
## Parameters:
## - bucket_name: Name of the bucket
## - storage_location: Location of the bucket
## - storage_class: Storage class of the bucket
## - google_kms_crypto_key_id: ID of the KMS crypto key
##----------------------------------------------------------------------------------------------------------------------
module "bronze_bucket" {
  source = "./modules/gcs_bucket"

  bucket_name              = var.bronze_bucket_name
  storage_location         = var.storage_location
  storage_class            = var.storage_class
  google_kms_crypto_key_id = module.google_kms_key.google_kms_crypto_key_id

  providers = {
    google.auth_session = google.auth_session
  }
}

##----------------------------------------------------------------------------------------------------------------------
## GOOGLE CLOUD STORAGE SILVER BUCKET MODULE
##
## Google Cloud Storage Bucket Module
##
## Parameters:
## - bucket_name: Name of the bucket
## - storage_location: Location of the bucket
## - storage_class: Storage class of the bucket
## - google_kms_crypto_key_id: ID of the KMS crypto key
##----------------------------------------------------------------------------------------------------------------------
module "silver_bucket" {
  source = "./modules/gcs_bucket"

  bucket_name              = var.silver_bucket_name
  storage_location         = var.storage_location
  storage_class            = var.storage_class
  google_kms_crypto_key_id = module.google_kms_key.google_kms_crypto_key_id

  providers = {
    google.auth_session = google.auth_session
  }
}

##----------------------------------------------------------------------------------------------------------------------
## GOOGLE CLOUD STORAGE GOLD BUCKET MODULE
##
## Google Cloud Storage Bucket Module
##
## Parameters:
## - bucket_name: Name of the bucket
## - storage_location: Location of the bucket
## - storage_class: Storage class of the bucket
## - google_kms_crypto_key_id: ID of the KMS crypto key
##----------------------------------------------------------------------------------------------------------------------
module "gold_bucket" {
  source = "./modules/gcs_bucket"

  bucket_name              = var.gold_bucket_name
  storage_location         = var.storage_location
  storage_class            = var.storage_class
  google_kms_crypto_key_id = module.google_kms_key.google_kms_crypto_key_id

  providers = {
    google.auth_session = google.auth_session
  }
}
