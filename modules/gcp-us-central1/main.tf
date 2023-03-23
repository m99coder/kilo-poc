provider "google" {
  project = "${var.project}"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_network" "kilo" {
  name = "kilo"
}

resource "google_compute_address" "static_ip" {
  name = "kilo"
}

resource "google_compute_firewall" "allow_ssh_wireguard" {
  name          = "allow-ssh-wireguard"
  network       = google_compute_network.kilo.name
  target_tags   = ["allow-ssh-wireguard"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "udp"
    ports    = ["51820"]
  }
}

resource "google_compute_instance" "node" {
  name         = "gcp-us-central1-node"
  machine_type = "f1-micro"
  tags         = ["allow-ssh-wireguard"]

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
