resource "google_container_cluster" "gke_cluster" {
  name     = "gaudiy-gke-cluster"
  location = "asia-northeast1-a"

  timeouts {
    create = "30m"
    update = "40m"
  }
  min_master_version = "latest"
  initial_node_count = 1

  node_config {
    machine_type = "n2d-standard-2"
    disk_size_gb = 50
    labels = {
        provisioner ="terraform"
    }
  }
  # Update deletion_protection to false
  deletion_protection = false

  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }
  }

 maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }
}

output "gke_endpoint" {
    value = google_container_cluster.gke_cluster.endpoint
}