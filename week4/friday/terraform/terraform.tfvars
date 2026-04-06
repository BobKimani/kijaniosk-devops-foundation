gcp_project_id      = "kijaniosk-devops"
gcp_region          = "africa-south1"
gcp_zone            = "africa-south1-a"
machine_type        = "e2-micro"
allowed_ssh_cidr    = "105.165.17.85/32"
ssh_user            = "ubuntu"
ssh_public_key_path = "~/.ssh/kijani-gcp.pub"

servers = {
  api = {
    instance_name = "kk-api"
  }
  payments = {
    instance_name = "kk-payments"
  }
  logs = {
    instance_name = "kk-logs"
  }
}