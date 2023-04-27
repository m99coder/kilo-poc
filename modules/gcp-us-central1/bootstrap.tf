module "bootstrap" {
  source = "../../modules/bootstrap"

  instance_public_ip = google_compute_address.static_ip.address
  ssh_username       = "tf-serviceaccount"

  k3s_leader_endpoint   = "https://${var.k3s_leader_endpoint}:6443"
  k3s_topology_location = "gcp"
  region = "us-central-1"

  depends_on = [
    google_compute_address.static_ip,
    google_compute_instance.node
  ]
}
