# ========================================
# Backend para AWS - S3 + DynamoDB
# ========================================
# Archivo: terraform/aws/backend.tf

terraform {
  backend "s3" {
    bucket         = var.bucket_name  # Cambiar esto
    key            = "databricks-poc/terraform.tfstate"
    region         = var.region
    encrypt        = true
    dynamodb_table = "terraform-state-lock"  # Para locking
    
    # Opcional: versionado del state
    versioning     = true
  }
}