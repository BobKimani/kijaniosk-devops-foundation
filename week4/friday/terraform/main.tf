terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  backend "gcs" {
    bucket = "kijanikiosk-tf-state-bobkimani"
    prefix = "week4/friday/state"
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.project_name}-${var.environment}-allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.allowed_ssh_cidr]
  target_tags   = ["kijanikiosk"]
}

resource "google_compute_firewall" "allow_api" {
  name    = "${var.project_name}-${var.environment}-allow-api"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["kijanikiosk", "api"]
}

resource "google_compute_firewall" "allow_payments" {
  name    = "${var.project_name}-${var.environment}-allow-payments"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9090"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["kijanikiosk", "payments"]
}

resource "google_compute_firewall" "allow_logs" {
  name    = "${var.project_name}-${var.environment}-allow-logs"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["5601"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["kijanikiosk", "logs"]
}

module "app_server" {
  source = "./modules/app_server"

  for_each = var.servers

  instance_name       = each.value.instance_name
  machine_type        = var.machine_type
  zone                = var.gcp_zone
  project_name        = var.project_name
  environment         = var.environment
  ssh_user            = var.ssh_user
  ssh_public_key_path = var.ssh_public_key_path
  network_tags        = ["kijanikiosk", each.key]
}