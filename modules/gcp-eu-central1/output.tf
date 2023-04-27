output "public_ip" {
  value = google_compute_address.static_ip.address
}
