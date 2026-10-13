output "bronze_bucket_name" {
  description = "The bronze bucket name."
  value       = module.data_lake.bronze_bucket_name
}

output "bronze_bucket_url" {
  description = "The bronze bucket URL."
  value       = module.data_lake.bronze_bucket_url
}

output "bronze_bucket_location" {
  description = "The bronze bucket location."
  value       = module.data_lake.bronze_bucket_location
}

output "silver_bucket_name" {
  description = "The silver bucket name."
  value       = module.data_lake.silver_bucket_name
}

output "silver_bucket_url" {
  description = "The silver bucket URL."
  value       = module.data_lake.silver_bucket_url
}

output "silver_bucket_location" {
  description = "The silver bucket location."
  value       = module.data_lake.silver_bucket_location
}

output "gold_bucket_name" {
  description = "The gold bucket name."
  value       = module.data_lake.gold_bucket_name
}

output "gold_bucket_url" {
  description = "The gold bucket URL."
  value       = module.data_lake.gold_bucket_url
}

output "gold_bucket_location" {
  description = "The gold bucket location."
  value       = module.data_lake.gold_bucket_location
}

output "google_service_account" {
  description = "Newly created GCP Service Account"
  value       = module.service_account_auth.service_account_email
}

output "google_oauth_access_token" {
  description = "Service Account OAuth Access Token"
  value       = module.service_account_auth.access_token
  sensitive   = true
}