provider "google" {
  credentials = file("${path.module}/../../gcp.json")

  project = "kilo-poc"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_network" "kilo" {
  name = "kilo"
}

resource "google_compute_address" "static_ip" {
  name = "kilo"
}

resource "google_compute_firewall" "allow_ssh" {
  name          = "allow-ssh"
  network       = google_compute_network.kilo.name
  target_tags   = ["allow-ssh"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "allow_wireguard" {
  name          = "allow-wireguard"
  network       = google_compute_network.kilo.name
  target_tags   = ["allow-wireguard"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "udp"
    ports    = ["51820"]
  }
}
resource "google_compute_instance" "node" {
  name         = "gcp-us-central1-node"
  machine_type = "f1-micro"
  tags         = ["allow-ssh", "allow-wireguard"]

  metadata = {
    ssh-keys = "tf-serviceaccount:${var.public_ssh_key}"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.kilo.name
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }
}
