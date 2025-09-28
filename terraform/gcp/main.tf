# Proveedor de GCP
provider "google" {
  project = var.project_id
  region  = var.region
}

# Bucket de Google Cloud Storage para datos
resource "google_storage_bucket" "data_bucket" {
  name          = var.bucket_name
  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true

  labels = {
    environment = "dev"
    project     = "databricks-poc"
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30  # Eliminar objetos después de 30 días
    }
  }
}

# Clúster de Dataproc para procesamiento distribuido
resource "google_dataproc_cluster" "dataproc_cluster" {
  name     = "dataproc-cluster-${random_id.suffix.hex}"
  region   = var.region

  cluster_config {
    staging_bucket = google_storage_bucket.data_bucket.name

    master_config {
      num_instances = 1
      machine_type  = var.machine_type_master
    }

    worker_config {
      num_instances = 2
      machine_type  = var.machine_type_worker
    }

    software_config {
      image_version = "2.0-debian10"
      optional_components = ["JUPYTER"]
    }
  }
}

# Generador de sufijo aleatorio para nombres únicos
resource "random_id" "suffix" {
  byte_length = 4
}