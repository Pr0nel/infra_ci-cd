# ========================================
# Backend para Azure - Storage Account
# ========================================
# Archivo: terraform/azure/backend.tf

terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstate${var.project_id}"  # Debe ser único globalmente
    container_name       = "tfstate"
    key                  = "databricks-poc.tfstate"
    
    # Opcional: usar managed identity
    use_msi              = true
  }
}