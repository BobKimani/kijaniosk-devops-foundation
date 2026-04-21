output "public_ip" {
  description = "Public IP address of the instance"
  value       = google_compute_instance.this.network_interface[0].access_config[0].nat_ip
}

output "instance_id" {
  description = "ID of the instance"
  value       = google_compute_instance.this.instance_id
}