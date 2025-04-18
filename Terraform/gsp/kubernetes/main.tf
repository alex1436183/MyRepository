provider "google" {
  project = "glossy-precinct-450612-g6"
  region  = "europe-north1"
}

resource "google_container_cluster" "master" {
  name     = "my-gke-cluster"
  location = "europe-north1-a"

  remove_default_node_pool = true
  initial_node_count       = 1


  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  deletion_protection = false
}

resource "google_container_node_pool" "worker_nodes" {
  name       = "my-node-pool"
  location   = "europe-north1-a"
  cluster    = google_container_cluster.master.name
  node_count = 2

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 20
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    labels = {
      environment = "production"
    }
    tags = ["k8s-node"]
  }
  autoscaling {
    min_node_count = 2
    max_node_count = 5
  }
}
