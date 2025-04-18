
resource "google_compute_network" "avl_vpc" {
  name                    = "avl-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "avl_subnet" {
  name          = "avl-subnet"
  network       = google_compute_network.avl_vpc.self_link
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-north1"
}

resource "google_compute_firewall" "http_https_ssh" {
  name    = "allow-http-https-ssh"
  network = google_compute_network.avl_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
