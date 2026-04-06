# Hardening Decisions for KijaniKiosk Staging Environment

## Overview

This document outlines the security hardening measures applied to the KijaniKiosk staging environment deployed on Google Cloud Platform. The system provisions three servers (API, Payments, Logs) and applies automated configuration using Ansible. The goal is to reduce attack surface, enforce access control, and ensure system reliability while maintaining simplicity and reproducibility.

---

## Security Controls Implemented

| Control | Description | Benefit | Trade-off |
|--------|------------|--------|----------|
| Restricted SSH Access | SSH access is limited to a single IP using CIDR (`/32`) | Prevents unauthorized access from the internet | Requires a stable public IP |
| Key-Based Authentication | SSH uses private/public key pairs instead of passwords | Stronger authentication and reduced brute-force risk | Requires secure key storage |
| Firewall Rules per Service | Only required ports are opened (8080, 9090, 5601) | Reduces exposed attack surface | Requires proper port planning |
| UFW Firewall Enabled | OS-level firewall is enabled on each VM | Adds an extra layer of security | Additional configuration overhead |
| Service Isolation via Users | Separate system users created for each service | Limits privilege escalation risks | More user management required |
| Systemd Service Management | Services are managed using systemd | Ensures reliability and auto-restart | Requires correct service configuration |
| Automatic Package Updates | `apt update` and required packages installed | Ensures system is patched and up to date | Slight delay during provisioning |
| Logging Enabled (journald) | Persistent logging enabled on all servers | Improves monitoring and troubleshooting | Increased disk usage |
| Log Rotation (logrotate) | Logs are rotated and cleaned automatically | Prevents disk exhaustion | Needs proper configuration tuning |

---

## Design Decisions

The system is designed using Infrastructure as Code (Terraform) and Configuration Management (Ansible). Terraform is responsible for provisioning infrastructure, while Ansible configures the servers.

A reusable Terraform module (`app_server`) is used to ensure consistency across all instances. This makes the infrastructure scalable and easier to maintain.

The environment is labeled as `staging` to allow safe testing before production deployment. Labels such as `project=kijanikiosk` and `environment=staging` improve organization and traceability within the cloud environment.

---

## Trade-offs and Limitations

While the system implements key security measures, some limitations exist:

- No Intrusion Detection System (IDS) is implemented
- No centralized logging system (e.g., ELK stack)
- No secrets management solution (e.g., Vault or Google Secret Manager)
- No HTTPS/TLS encryption for services
- No network segmentation (default VPC is used)

These trade-offs were made to keep the system simple and aligned with the assignment requirements.

---

## Gaps and Future Improvements

To improve security and scalability, the following enhancements can be implemented:

- Add HTTPS using a reverse proxy such as Nginx
- Use Google Secret Manager for handling sensitive data
- Implement centralized logging using ELK or Cloud Logging
- Introduce network segmentation using custom VPCs and subnets
- Add monitoring and alerting using Prometheus or Google Cloud Monitoring
- Implement IAM roles for fine-grained access control

---

## Conclusion

The KijaniKiosk staging environment demonstrates a secure and reproducible DevOps setup using Terraform and Ansible. While not fully production-grade, it incorporates essential security practices and provides a strong foundation for further improvements.