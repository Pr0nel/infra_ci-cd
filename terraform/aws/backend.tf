# ========================================
# Backend para AWS - S3 + DynamoDB
# ========================================
# Archivo: terraform/aws/backend.tf

terraform {
  backend "s3" {
    # Bucket, region, dynamodb_table se configura en rutine, usando secret de GitHub Actions. TF_BACKEND_BUCKET, TF_VAR_REGION, TF_BACKEND_DYNAMODB_TABLE.
    key            = "databricks-poc/terraform.tfstate"
    encrypt        = true
    # Opcional: versionado del state
    versioning     = true
  }
}