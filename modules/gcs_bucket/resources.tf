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

data "google_storage_project_service_account" "this" {
  provider = google.auth_session
}


resource "google_kms_crypto_key_iam_binding" "this" {
  provider = google.auth_session

  crypto_key_id = var.google_kms_crypto_key_id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members = [
    "serviceAccount:${data.google_storage_project_service_account.this.email_address}",
  ]
}

##----------------------------------------------------------------------------------------------------------------------
## GOOGLE STORAGE BUCKET
##
## Google Cloud Storage Bucket creation.
##
## Parameters:
## - `name`: GCS bucket name
## - `storage_class`: GCS Blob storage type
## - `location`: GCS region
## - `uniform_bucket_level_access`: Flag to uniformly control access to your Cloud Storage resources
## ---------------------------------------------------------------------------------------------------------------------
resource "google_storage_bucket" "this" {
  provider   = google.auth_session
  depends_on = [google_kms_crypto_key_iam_binding.this]

  name                        = var.bucket_name
  storage_class               = var.storage_class
  location                    = var.storage_location
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  hierarchical_namespace {
    enabled = true
  }

  encryption {
    default_kms_key_name = var.google_kms_crypto_key_id
  }

  # Rule to archive objects
  lifecycle_rule {
    action {
      type          = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
    condition {
      age = var.storage_lifecycle_archival_days
    }
  }

  # Rule to delete objects
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = var.storage_lifecycle_deletion_days
    }
  }

  force_destroy = true
}
