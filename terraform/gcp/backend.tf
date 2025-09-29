# ========================================
# Backend para GCP - Cloud Storage
# ========================================
# Archivo: terraform/gcp/backend.tf

terraform {
  backend "gcs" {
    # Bucket se configura en rutine, usando secret de GitHub Actions.
    prefix  = "databricks-poc/state"
  }
}