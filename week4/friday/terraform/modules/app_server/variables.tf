variable "instance_name" {
  description = "Name of the compute instance"
  type        = string
}

variable "machine_type" {
  description = "Compute Engine machine type"
  type        = string
}

variable "zone" {
  description = "Compute Engine zone"
  type        = string
}

variable "project_name" {
  description = "Project name used for labels"
  type        = string
}

variable "environment" {
  description = "Environment used for labels"
  type        = string
}

variable "ssh_user" {
  description = "SSH username"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
}

variable "network_tags" {
  description = "Network tags applied to the instance"
  type        = list(string)
}