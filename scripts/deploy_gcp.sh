#!/bin/bash
echo "Desplegando recursos en GCP..."

# Variables
PROJECT_ID="${TF_VAR_project_id}"
BUCKET_NAME="${TF_VAR_bucket_name}"
REGION="${TF_VAR_region}"

# Validar variables obligatorias
if [[ -z "${PROJECT_ID}" || -z "${BUCKET_NAME}" || -z "${REGION}" ]]; then
  echo "Error: Las variables PROJECT_ID, BUCKET_NAME y REGION deben estar definidas."
  exit 1
fi

# Verificar la existencia del bucket
if ! gsutil ls "gs://${BUCKET_NAME}" &>/dev/null; then
  echo "Error: El bucket gs://${BUCKET_NAME} no existe."
  exit 1
fi

# Copiar datos iniciales al bucket de GCP
echo "Copiando datos iniciales al bucket..."
gsutil -m cp -r ../mi-proyecto/data/* gs://${BUCKET_NAME}/data/

# Verificar la existencia del clúster de Dataproc
# Generar sufijo aleatorio
RANDOM_SUFFIX=$(date +%s | sha256sum | base64 | head -c 8)
CLUSTER_NAME="dataproc-cluster-${RANDOM_SUFFIX}"
if ! gcloud dataproc clusters describe "${CLUSTER_NAME}" --region="${REGION}" &>/dev/null; then
  echo "Error: El clúster ${CLUSTER_NAME} no existe en la región ${REGION}."
  exit 1
fi

# Ejecutar el pipeline en Dataproc
echo "Ejecutando el pipeline en Dataproc..."
gcloud dataproc jobs submit pyspark \
    --cluster=dataproc-cluster-${RANDOM_SUFFIX} \
    --region=${REGION} \
    --properties=spark.submit.deployMode=cluster \
    gs://${BUCKET_NAME}/src/main.py\
    -- \
    --input=gs://${BUCKET_NAME}/data/input.csv \
    --output=gs://${BUCKET_NAME}/data/output/

echo "Pipeline ejecutado exitosamente."