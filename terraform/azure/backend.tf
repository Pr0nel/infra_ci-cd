# ========================================
# Backend para Azure - Storage Account
# ========================================
# Archivo: terraform/azure/backend.tf

terraform {
  backend "azurerm" {
    # storage_account_name se configura en rutine, usando secret de GitHub Actions. TF_BACKEND_STORAGE_ACCOUNT, TF_BACKEND_RESOURCE_GROUP, TF_BACKEND_RESOURCE_GROUP.
    container_name       = "tfstate"
    key                  = "databricks-poc.tfstate"
    # Opcional: usar managed identity
    use_msi              = true
  }
}