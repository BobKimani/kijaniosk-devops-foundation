# Demo Script: Blue/Green Deployment and Automated Rollback

## Objective

This demo shows how the KijaniKiosk API supports safe deployments using blue/green environments, controlled traffic switching, and automated rollback based on health checks.

---

## Starting State

Explain:

The system is running two environments:

- Blue environment (v1.3.0) on port 3000
- Green environment (v1.4.0) on port 3001

Only one environment receives traffic at a time through nginx on port 80.

---

## Step 1: Verify both environments

COMMAND:

systemctl is-active kk-api-blue.service  
systemctl is-active kk-api-green.service

curl -s http://127.0.0.1:3000/health  
curl -s http://127.0.0.1:3001/health

Explain:

Both environments are running and healthy independently.

---

## Step 2: Verify active environment

COMMAND:

curl -s http://127.0.0.1:80/health  
cat /opt/kijanikiosk/.active-env

Explain:

Traffic is currently routed to the active environment through nginx.

---

## Step 3: Switch traffic to green

COMMAND:

sudo bash /opt/kijanikiosk/scripts/switch-env.sh green

Explain:

This updates nginx configuration and reloads it without downtime.

---

## Step 4: Verify switch

COMMAND:

curl -s http://127.0.0.1:80/health  
cat /opt/kijanikiosk/.active-env  
cat /opt/kijanikiosk/.previous-env

Explain:

Traffic is now served by the green environment (v1.4.0), and state files track the change.

---

## Step 5: Start monitoring

COMMAND:

sudo bash /opt/kijanikiosk/scripts/post-deploy-monitor.sh 60

Explain:

The monitor continuously checks service health and can trigger rollback automatically.

---

## Step 6: Introduce failure

COMMAND:

sudo systemctl stop kk-api-green.service

Explain:

This simulates a failed deployment.

---

## Step 7: Observe automated rollback

Explain:

The monitor detects multiple failures and triggers rollback to the blue environment automatically.

---

## Step 8: Verify rollback

COMMAND:

curl -s http://127.0.0.1:80/health  
cat /opt/kijanikiosk/.active-env  
cat /opt/kijanikiosk/.previous-env

Explain:

Traffic has returned to blue (v1.3.0), and system state reflects the rollback.

---

## Key Takeaways

- Blue/green deployment allows zero-downtime releases
- Health-based monitoring enables fast failure detection
- Automated rollback protects users without manual intervention
- System state tracking ensures traceability of changes
