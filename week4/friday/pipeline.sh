#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$ROOT_DIR/terraform"
ANSIBLE_DIR="$ROOT_DIR/ansible"

echo "Starting Terraform apply..."
cd "$TERRAFORM_DIR"
terraform init
terraform apply -auto-approve

echo "Extracting Terraform outputs..."
API_IP=$(terraform output -raw api_server_ip)
PAYMENTS_IP=$(terraform output -raw payments_server_ip)
LOGS_IP=$(terraform output -raw logs_server_ip)

echo "Writing dynamic Ansible inventory..."
cat > "$ANSIBLE_DIR/inventory.ini" <<EOF
[kijanikiosk]
api ansible_host=${API_IP}
payments ansible_host=${PAYMENTS_IP}
logs ansible_host=${LOGS_IP}
EOF

echo "Running Ansible playbook..."
cd "$ANSIBLE_DIR"
ansible-playbook -i inventory.ini kijanikiosk.yml