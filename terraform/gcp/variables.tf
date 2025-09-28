variable "project_id" {
  description = "ID del proyecto de Google Cloud Platform"
  type        = string
}

variable "region" {
  description = "Región de GCP donde se creará los recursos"
  type        = string
}

variable "bucket_name" {
  description = "Nombre del bucket de Google Cloud Storage"
  type        = string
}

variable "machine_type_master" {
  description = "Tipo de máquina para el nodo maestro de Dataproc"
  default     = "n1-standard-4"
}

variable "machine_type_worker" {
  description = "Tipo de máquina para los nodos trabajadores de Dataproc"
  default     = "n1-standard-4"
}