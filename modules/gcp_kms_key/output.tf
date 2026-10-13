output "google_kms_key_ring_id" {
  value = google_kms_key_ring.this.id
}

output "google_kms_crypto_key_id" {
  value = google_kms_crypto_key.this.id
}

output "google_kms_crypto_key_name" {
  value = google_kms_crypto_key.this.name
}
