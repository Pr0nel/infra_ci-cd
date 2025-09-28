#!/bin/bash
echo "Desplegando recursos en AWS..."

# Copiar archivos iniciales al bucket S3
aws s3 cp project-code/data/ s3://${TF_VAR_bucket_name}/data/ --recursive

# Ejecutar el pipeline del proyecto
cd project-code/src
python main.py