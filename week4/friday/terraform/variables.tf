variable "gcp_project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "gcp_region" {
  description = "Google Cloud region"
  type        = string
}

variable "gcp_zone" {
  description = "Google Cloud zone"
  type        = string
}

variable "machine_type" {
  description = "Compute Engine machine type"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to access the servers over SSH"
  type        = string
}

variable "ssh_user" {
  description = "SSH username for the instances"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
}

variable "project_name" {
  description = "Project name used for tagging resources"
  type        = string
  default     = "kijanikiosk"
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "staging"
}

variable "servers" {
  description = "Map of server definitions keyed by role name"
  type = map(object({
    instance_name = string
  }))
}