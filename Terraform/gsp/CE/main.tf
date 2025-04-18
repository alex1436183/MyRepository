provider "google" {
  project = "glossy-precinct-450612-g6"
  region  = "europe-north1"
}

resource "google_compute_instance" "ubuntu_ce" {
  name         = var.instance_name
  machine_type = "e2-micro"
  zone         = "europe-north1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
    }
  }

  metadata = {
    ssh-keys = "alex5482671al:${file("./key.pub")}"
  }

  tags = ["ssh"]

  network_interface {
    network = "default"
    access_config {}
  }
}
