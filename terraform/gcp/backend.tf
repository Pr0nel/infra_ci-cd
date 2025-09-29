# ========================================
# Backend para GCP - Cloud Storage
# ========================================
# Archivo: terraform/gcp/backend.tf

terraform {
  backend "gcs" {
    bucket  = var.bucket_name
    prefix  = "databricks-poc/state"
  }
}