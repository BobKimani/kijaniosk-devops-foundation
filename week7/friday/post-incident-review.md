# Post-Incident Review: kk-payments Service Disruption

## Incident Summary

During a deployment of the green environment (v1.4.0), the active payment service became unavailable due to a controlled failure introduced for testing. The monitoring system detected repeated health check failures and triggered an automated rollback to the blue environment (v1.3.0). Service was restored within seconds, and customer impact was minimized.

## Timeline

- 13:40:59 — Monitor started while green environment was active
- 13:41:10 — Fault introduced by stopping kk-api-green.service (T0)
- 13:41:14 — First failed health check detected
- 13:41:24 — Third consecutive failure detected; rollback triggered automatically (T1)
- 13:41:26 — Blue environment confirmed healthy through proxy (T2)

## Root Cause

The immediate cause of the incident was the shutdown of the green service instance, which resulted in the proxy routing traffic to an unavailable backend. This simulated a failed deployment scenario.

## Contributing Factors

- The proxy was actively routing traffic to the green environment at the time of failure
- There was no delay between failure and proxy request attempts, causing immediate service errors
- The initial monitor implementation verified rollback too quickly before nginx fully stabilized (later corrected with a short delay)

## What Went Well

- Health monitoring detected failure within seconds
- Automated rollback logic executed without manual intervention
- Proxy successfully switched back to blue environment
- Total recovery time was well within acceptable limits (under 90 seconds)
- System state files correctly reflected the new active and previous environments

## Action Items

- Maintain a short delay before post-rollback verification to avoid transient proxy errors
- Ensure all deployments are accompanied by active monitoring
- Extend monitoring to include latency and error rate signals, not just availability
- Document rollback procedures clearly for operational teams
