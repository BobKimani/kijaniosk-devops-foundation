# Access Model - Final

This document defines how access is controlled across the KijaniKiosk system.

## Directories and Access

### 1. Config Directory

Location: /opt/kijanikiosk/config

- Owner: root
- Group: kijanikiosk
- Access:
  - Read: kk-api, kk-payments
  - Write: root only

Purpose:
Protect sensitive configuration such as environment variables.

---

### 2. Logs Directory

Location: /opt/kijanikiosk/shared/logs

- Owner: root
- Group: kijanikiosk
- Access:
  - Write: kk-api
  - Read: kk-payments, kk-logs

Default ACLs applied:
All new files inherit permissions automatically.

Purpose:
Allow services to write logs while enabling monitoring and auditing.

---

### 3. Health Directory

Location: /opt/kijanikiosk/health

- Owner: kk-logs
- Group: kijanikiosk
- Permissions: 640

Access:

- Write: provisioning script
- Read: monitoring users

Purpose:
Store system health status in a controlled and readable format.

---

## Logrotate Interaction

When logs rotate:

- New files are created
- Default ACLs ensure permissions remain correct

Verification:
kk-api can still write after rotation

---

## Summary

This model ensures:

- Separation of responsibilities
- Controlled access to sensitive data
- Continued functionality after log rotation
