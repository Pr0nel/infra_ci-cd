output "bucket_name" {
  description = "Nombre del bucket de Google Cloud Storage creado"
  value       = google_storage_bucket.data_bucket.name
}

output "dataproc_cluster_name" {
  description = "Nombre del clúster de Dataproc creado"
  value       = google_dataproc_cluster.dataproc_cluster.name
}

output "dataproc_cluster_url" {
  description = "URL del clúster de Dataproc en la consola de GCP"
  value       = "https://console.cloud.google.com/dataproc/clusters/${google_dataproc_cluster.dataproc_cluster.name}/monitoring?project=${var.project_id}&region=${var.region}"
}