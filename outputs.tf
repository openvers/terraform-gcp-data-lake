output "bronze_bucket_name" {
  description = "The bronze bucket name."
  value       = module.bronze_bucket.bucket_name
}

output "bronze_bucket_url" {
  description = "The bronze bucket URL."
  value       = module.bronze_bucket.bucket_url
}

output "bronze_bucket_location" {
  description = "The bronze bucket location."
  value       = module.bronze_bucket.bucket_location
}

output "silver_bucket_name" {
  description = "The silver bucket name."
  value       = module.silver_bucket.bucket_name
}

output "silver_bucket_url" {
  description = "The silver bucket URL."
  value       = module.silver_bucket.bucket_url
}

output "silver_bucket_location" {
  description = "The silver bucket location."
  value       = module.silver_bucket.bucket_location
}

output "gold_bucket_name" {
  description = "The gold bucket name."
  value       = module.gold_bucket.bucket_name
}

output "gold_bucket_url" {
  description = "The gold bucket URL."
  value       = module.gold_bucket.bucket_url
}

output "gold_bucket_location" {
  description = "The gold bucket location."
  value       = module.gold_bucket.bucket_location
}
