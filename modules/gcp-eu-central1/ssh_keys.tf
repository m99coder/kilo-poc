module "ssh_keys" {
  source = "../../modules/ssh_keys"

  instance_public_ip = google_compute_address.static_ip.address
  ssh_username       = "tf-serviceaccount"

  depends_on = [
    google_compute_address.static_ip,
    google_compute_instance.node
  ]
}
