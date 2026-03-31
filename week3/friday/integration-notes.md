# Integration Notes

## Challenge 1: ProtectSystem vs Config Files

Problem:
Strict system protection can block access to configuration files.

Solution:
Stored configs under /opt/kijanikiosk/config and ensured readable permissions.

Reason:
This avoids conflict with read-only system paths.

---

## Challenge 2: Health Directory Access

Problem:
Health file created by root but needs to be readable.

Solution:
Assigned ownership to kk-logs group and set 640 permissions.

Reason:
Ensures controlled read access without exposing system files.

---

## Challenge 3: Logrotate Interaction

Problem:
New files after rotation may break access.

Solution:
Used default ACLs on directory to enforce permissions inheritance.

Reason:
Ensures services can still write after rotation.

---

## Challenge 4: Package State

Problem:
Packages already installed or held.

Solution:
Reinstalled only necessary packages without forcing downgrade.

Reason:
Safer than modifying production system unexpectedly.
