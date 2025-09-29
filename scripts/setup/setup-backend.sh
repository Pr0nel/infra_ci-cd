#!/bin/bash
# scripts/setup/setup-backend.sh
# Script para crear el bucket de backend de Terraform
# Se ejecuta automáticamente en el pipeline antes de terraform init
set -euo pipefail
# ============================================
# Función para logging
# ============================================
log_info() { echo "$1" }
log_success() { echo "$1" }
log_error() { echo "$1" >&2 }
log_warning() { echo "$1" }
# ============================================
# Variables (pasadas desde el pipeline)
# ============================================
CLOUD_PROVIDER="${1:-}"
BUCKET_NAME="${2:-}"
REGION="${3:-}"
PROJECT_ID="${4:-}"

# Validar argumentos
if [[ -z "${CLOUD_PROVIDER}" ]] || [[ -z "${BUCKET_NAME}" ]] || [[ -z "${REGION}" ]]; then
    log_error "Uso: $0 <cloud_provider> <bucket_name> <region> [project_id]"
    exit 1
fi
# ============================================
# Función para GCP
# ============================================
setup_gcp_backend() {
    log_info "Configurando backend de Terraform en GCP..."
    if gsutil ls "gs://${BUCKET_NAME}" &>/dev/null; then
        log_success "Bucket gs://${BUCKET_NAME} ya existe"
        return 0
    fi
    log_info "Creando bucket gs://${BUCKET_NAME}..."
    if [[ -n "${PROJECT_ID}" ]]; then
        gsutil mb -p "${PROJECT_ID}" -l "${REGION}" "gs://${BUCKET_NAME}"
    else
        gsutil mb -l "${REGION}" "gs://${BUCKET_NAME}"
    fi
    log_info "Habilitando versionado en el bucket..."
    gsutil versioning set on "gs://${BUCKET_NAME}"
    log_info "Configurando lifecycle policy..."
    cat > /tmp/lifecycle.json << 'EOF'
{
  "lifecycle": {
    "rule": [{
      "action": {"type": "Delete"},
      "condition": {"numNewerVersions": 10}
    }]
  }
}
EOF
    gsutil lifecycle set /tmp/lifecycle.json "gs://${BUCKET_NAME}"
    rm -f /tmp/lifecycle.json
    log_info "Verificando acceso al bucket..."
    if gsutil ls "gs://${BUCKET_NAME}" >/dev/null 2>&1; then
        log_success "Bucket creado y accesible exitosamente"
    else
        log_error "Bucket creado pero no es accesible"
        return 1
    fi
}
# ============================================
# Función para AWS
# ============================================
setup_aws_backend() {
    log_info "Configurando backend de Terraform en AWS..."
    local DYNAMODB_TABLE="${5:-terraform-state-lock}"
    if aws s3 ls "s3://${BUCKET_NAME}" &>/dev/null; then
        log_success "Bucket s3://${BUCKET_NAME} ya existe"
    else
        log_info "Creando bucket S3 ${BUCKET_NAME}..."
        aws s3 mb "s3://${BUCKET_NAME}" --region "${REGION}"
        log_info "Habilitando versionado..."
        aws s3api put-bucket-versioning \
            --bucket "${BUCKET_NAME}" \
            --versioning-configuration Status=Enabled
        log_info "Habilitando encriptación..."
        aws s3api put-bucket-encryption \
            --bucket "${BUCKET_NAME}" \
            --server-side-encryption-configuration '{
                "Rules": [{
                    "ApplyServerSideEncryptionByDefault": {
                        "SSEAlgorithm": "AES256"
                    },
                    "BucketKeyEnabled": true
                }]
            }'
        log_info "Bloqueando acceso público..."
        aws s3api put-public-access-block \
            --bucket "${BUCKET_NAME}" \
            --public-access-block-configuration \
            "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
        log_success "Bucket S3 creado exitosamente"
    fi
    if aws dynamodb describe-table --table-name "${DYNAMODB_TABLE}" --region "${REGION}" &>/dev/null; then
        log_success "Tabla DynamoDB ${DYNAMODB_TABLE} ya existe"
    else
        log_info "Creando tabla DynamoDB ${DYNAMODB_TABLE}..."
        aws dynamodb create-table \
            --table-name "${DYNAMODB_TABLE}" \
            --attribute-definitions AttributeName=LockID,AttributeType=S \
            --key-schema AttributeName=LockID,KeyType=HASH \
            --billing-mode PAY_PER_REQUEST \
            --region "${REGION}" \
            --tags Key=Purpose,Value=TerraformStateLock  
        log_info "Esperando que la tabla esté disponible..."
        aws dynamodb wait table-exists \
            --table-name "${DYNAMODB_TABLE}" \
            --region "${REGION}"
        log_success "Tabla DynamoDB creada exitosamente"
    fi
}
# ============================================
# Función para Azure
# ============================================
setup_azure_backend() {
    log_info "Configurando backend de Terraform en Azure..."   
    local RESOURCE_GROUP="${5:-terraform-state-rg}"
    local STORAGE_ACCOUNT="tfstate$(date +%s | sha256sum | base64 | head -c 8)"
    local CONTAINER_NAME="tfstate"
    if az group show --name "${RESOURCE_GROUP}" &>/dev/null; then
        log_success "Resource Group ${RESOURCE_GROUP} ya existe"
    else
        log_info "Creando Resource Group ${RESOURCE_GROUP}..."
        az group create \
            --name "${RESOURCE_GROUP}" \
            --location "${REGION}"
        log_success "Resource Group creado exitosamente"
    fi
    if az storage account show \
        --name "${STORAGE_ACCOUNT}" \
        --resource-group "${RESOURCE_GROUP}" &>/dev/null; then
        log_success "Storage Account ${STORAGE_ACCOUNT} ya existe"
    else
        log_info "Creando Storage Account ${STORAGE_ACCOUNT}..."
        az storage account create \
            --name "${STORAGE_ACCOUNT}" \
            --resource-group "${RESOURCE_GROUP}" \
            --location "${REGION}" \
            --sku Standard_LRS \
            --encryption-services blob \
            --min-tls-version TLS1_2
        log_success "Storage Account creado exitosamente"
    fi
    local ACCOUNT_KEY
    ACCOUNT_KEY=$(az storage account keys list \
        --resource-group "${RESOURCE_GROUP}" \
        --account-name "${STORAGE_ACCOUNT}" \
        --query '[0].value' -o tsv)
    if az storage container show \
        --name "${CONTAINER_NAME}" \
        --account-name "${STORAGE_ACCOUNT}" \
        --account-key "${ACCOUNT_KEY}" &>/dev/null; then
        log_success "Container ${CONTAINER_NAME} ya existe"
    else
        log_info "Creando Container ${CONTAINER_NAME}..."
        az storage container create \
            --name "${CONTAINER_NAME}" \
            --account-name "${STORAGE_ACCOUNT}" \
            --account-key "${ACCOUNT_KEY}"
        log_success "Container creado exitosamente"
    fi
}
# ============================================
# Main
# ============================================
main() {
    log_info "Iniciando configuración del backend..."
    log_info "Proveedor: ${CLOUD_PROVIDER}"
    log_info "Bucket/Storage: ${BUCKET_NAME}"
    log_info "Región: ${REGION}"   
    case "${CLOUD_PROVIDER}" in
        gcp)
            setup_gcp_backend
            ;;
        aws)
            setup_aws_backend
            ;;
        azure)
            setup_azure_backend
            ;;
        *)
            log_error "Proveedor no soportado: ${CLOUD_PROVIDER}"
            log_error "Proveedores válidos: gcp, aws, azure"
            exit 1
            ;;
    esac
    log_success "Backend configurado exitosamente"
}
main "$@"