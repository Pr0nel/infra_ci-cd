#!/bin/bash
echo "Desplegando recursos en Azure..."

# Copiar archivos iniciales al Blob Storage
az storage blob upload-batch --destination ${TF_VAR_container_name} --source project-code/data/

# Ejecutar el pipeline del proyecto
cd project-code/src
python main.py