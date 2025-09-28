output "bucket_name" {
  description = "Nombre del bucket de Google Cloud Storage creado"
  value       = google_storage_bucket.data_bucket.name
}

output "dataproc_cluster_name" {
  description = "Nombre del clúster de Dataproc creado"
  value       = google_dataproc_cluster.dataproc_cluster.name
}