output "cluster_endpoint" {
  value = google_container_cluster.master.endpoint
}

output "cluster_name" {
  value = google_container_cluster.master.name
}
