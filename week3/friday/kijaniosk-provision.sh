#!/bin/bash
set -e

LOG_FILE="provision.log"
exec > >(tee -a "$LOG_FILE") 2>&1

log() { echo "[INFO] $1"; }
fail() { echo "[FAIL] $1"; exit 1; }
pass() { echo "[PASS] $1"; }

# PHASE 1: PRECHECK

log "Phase 1: Detecting existing state"

id kk-api &>/dev/null && log "User kk-api exists"
id kk-payments &>/dev/null && log "User kk-payments exists"
id kk-logs &>/dev/null && log "User kk-logs exists"

# PHASE 2: USERS & GROUPS

log "Phase 2: Users and groups"

getent group kijanikiosk || groupadd kijanikiosk

id kk-api &>/dev/null || useradd -r -s /usr/sbin/nologin -g kijanikiosk kk-api
id kk-payments &>/dev/null || useradd -r -s /usr/sbin/nologin -g kijanikiosk kk-payments
id kk-logs &>/dev/null || useradd -r -s /usr/sbin/nologin -g kijanikiosk kk-logs

# PHASE 3: DIRECTORIES & ACL

log "Phase 3: Directories and ACLs"

mkdir -p /opt/kijanikiosk/{config,shared/logs,health}

chown -R root:kijanikiosk /opt/kijanikiosk
chmod -R 750 /opt/kijanikiosk

setfacl -R -m g:kijanikiosk:rwx /opt/kijanikiosk/shared/logs
setfacl -d -m g:kijanikiosk:rwx /opt/kijanikiosk/shared/logs

# PHASE 4: PACKAGES

log "Phase 4: Packages"

apt update -y
apt install -y nginx curl

# PHASE 5: SYSTEMD SERVICES

log "Phase 5: Services"

cat <<EOF >/etc/systemd/system/kk-api.service
[Unit]
Description=KK API
After=network.target

[Service]
User=kk-api
Group=kijanikiosk
ExecStart=/usr/bin/node /opt/app/api.js
Restart=always
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=full

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF >/etc/systemd/system/kk-payments.service
[Unit]
Description=KK Payments
After=kk-api.service
Wants=kk-api.service

[Service]
User=kk-payments
Group=kijanikiosk
ExecStart=/usr/bin/node /opt/app/payments.js
Restart=always
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF >/etc/systemd/system/kk-logs.service
[Unit]
Description=KK Logs

[Service]
User=kk-logs
ExecStart=/bin/true
Restart=always
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

# PHASE 6: FIREWALL

log "Phase 6: Firewall"

ufw --force reset

ufw allow 22/tcp comment "SSH access"
ufw allow 80/tcp comment "HTTP traffic"
ufw allow from 10.0.1.0/24 to any port 3001 comment "Monitoring access"
ufw allow in on lo to any port 3001 comment "Loopback access"
ufw deny 3001 comment "Block external payments port"

ufw --force enable

# PHASE 7: LOGGING

log "Phase 7: Journald and logrotate"

mkdir -p /var/log/journal
sed -i 's/#Storage=.*/Storage=persistent/' /etc/systemd/journald.conf
sed -i 's/#SystemMaxUse=.*/SystemMaxUse=500M/' /etc/systemd/journald.conf

systemctl restart systemd-journald

cat <<EOF >/etc/logrotate.d/kijanikiosk
/opt/kijanikiosk/shared/logs/*.log {
    daily
    rotate 7
    compress
    create 640 root kijanikiosk
}
EOF

logrotate --debug /etc/logrotate.d/kijanikiosk || fail "logrotate failed"


# PHASE 8: HEALTH CHECK

log "Phase 8: Health check"

api_status=$(timeout 2 bash -c "echo >/dev/tcp/localhost/3000" 2>/dev/null && echo '"ok"' || echo '"down"')
payments_status=$(timeout 2 bash -c "echo >/dev/tcp/localhost/3001" 2>/dev/null && echo '"ok"' || echo '"down"')

printf '{"timestamp":"%s","kk-api":%s,"kk-payments":%s}\n' \
  "$(date -Is)" "$api_status" "$payments_status" \
  > /opt/kijanikiosk/health/last-provision.json

chown kk-logs:kijanikiosk /opt/kijanikiosk/health/last-provision.json
chmod 640 /opt/kijanikiosk/health/last-provision.json

pass "Provisioning complete"