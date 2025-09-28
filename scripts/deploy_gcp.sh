#!/bin/bash
echo "Desplegando recursos en GCP..."

# Variables
PROJECT_ID="${TF_VAR_project_id}"
BUCKET_NAME="${TF_VAR_bucket_name}"
REGION="${TF_VAR_region}"

# Copiar datos iniciales al bucket de GCP
echo "Copiando datos iniciales al bucket..."
gsutil -m cp -r ../mi-proyecto/data/* gs://${BUCKET_NAME}/data/

# Ejecutar el pipeline en Dataproc
echo "Ejecutando el pipeline en Dataproc..."
gcloud dataproc jobs submit pyspark \
    --cluster=dataproc-cluster-${RANDOM_SUFFIX} \
    --region=${REGION} \
    --properties=spark.submit.deployMode=cluster \
    gs://${BUCKET_NAME}/src/main.py

echo "Pipeline ejecutado exitosamente."