output "api_server_ip" {
  description = "Public IP of the api server"
  value       = module.app_server["api"].public_ip
}

output "payments_server_ip" {
  description = "Public IP of the payments server"
  value       = module.app_server["payments"].public_ip
}

output "logs_server_ip" {
  description = "Public IP of the logs server"
  value       = module.app_server["logs"].public_ip
}

output "ssh_commands" {
  description = "SSH commands for all servers"
  value = {
    api      = "ssh ${var.ssh_user}@${module.app_server["api"].public_ip}"
    payments = "ssh ${var.ssh_user}@${module.app_server["payments"].public_ip}"
    logs     = "ssh ${var.ssh_user}@${module.app_server["logs"].public_ip}"
  }
}