# KijaniKiosk API Server - Triage Report

**Date:** March 29, 2026
**Investigated by:** Bob Kimani
**Server:** shanti-VirtualBox
**Incident start (approximate):** 04:07 (from log evidence)

## Summary

The system experienced increased API latency due to a cascading backend failure originating from database instability. Evidence shows database connection pool exhaustion, followed by query timeouts and eventual connection refusal. This was compounded by memory pressure from a resource-intensive process, leading to degraded overall system performance.

## Process and Resource State

System analysis shows several active processes, with the most significant being a Python process consuming approximately 500MB of memory. Additional high-memory processes include the browser (Firefox) and the GNOME shell, though these are expected in a desktop-based VM environment.

CPU utilization is moderate overall, with no single process consistently saturating CPU resources. However, memory usage is elevated, with approximately 2.7GB used out of 7.6GB total. While not fully exhausted, the presence of memory pressure is confirmed by active system memory management services.

There are multiple zombie processes present, indicating that some child processes have terminated without being properly cleaned up by their parent processes. While not immediately critical, this reflects poor process lifecycle management and contributes to system instability.

File descriptor analysis shows high usage by core system services such as dbus-daemon and systemd, but no clear indication of file descriptor exhaustion.

Overall, the system is under moderate memory pressure with signs of process mismanagement, but not in a fully resource-exhausted state.

## Filesystem and Disk

Disk usage across all mounted partitions is within acceptable limits, with the root partition at approximately 51% utilization. There is no immediate risk of disk exhaustion.

However, analysis of the /var/log directory reveals unusually large log files, particularly within /var/log/kijanikiosk, which consumes approximately 271MB. A specific rotated log file (access.log.1) is approximately 200MB in size, significantly larger than expected.

This indicates a failure in log rotation or retention policies. While disk space is currently sufficient, continued log growth at this rate poses a long-term risk of disk exhaustion.

Recent filesystem activity shows normal log updates, with no evidence of unexpected file creation outside the logging directories.

## Log Analysis

Log analysis reveals a clear pattern of escalating database-related errors. The most frequent issues include query timeouts and database connection failures (ECONNREFUSED), along with warnings indicating high database connection pool utilization.

The first critical error occurred at approximately 04:07, when the system reported that the database connection pool had been exhausted. This was immediately followed by query timeouts, indicating that requests were not being processed in a timely manner.

Later, at approximately 06:22, repeated ECONNREFUSED errors were observed, indicating that the database had become completely unreachable.

System logs show that the Out-Of-Memory (OOM) management service is active, but there is no evidence that processes were terminated due to memory exhaustion. This suggests that while memory pressure exists, it has not yet resulted in catastrophic failure.

Authentication logs show no suspicious activity, ruling out external intrusion or unauthorized access as a contributing factor.

Overall, the logs indicate a cascading failure beginning with database resource saturation, progressing to query failure, and culminating in total database unavailability.

## Network and Service State

Port binding analysis shows that port 80 (HTTP) is active and handled by the NGINX service. No backend service ports, such as 3000 (application) or 5432 (database), are actively listening.

HTTP requests to the local server return a 200 status code, confirming that NGINX is operational. However, response times are higher than expected, indicating delays in backend processing.

The absence of listening services on expected backend ports confirms that the application and/or database services are not running or are unreachable. This aligns with the ECONNREFUSED errors observed in the logs.

TCP connection states appear normal, with most connections in LISTEN or TIME-WAIT states. There is no evidence of abnormal connection patterns such as SYN flooding or excessive half-open connections.

Overall, the network stack is functioning correctly, and the issue is isolated to backend service availability rather than network failure.

## Assessment

The most likely root cause of the observed latency increase is a cascading failure originating from database resource exhaustion, compounded by system-level memory pressure.

Log analysis shows that the first signs of degradation began at approximately 04:07, when the application reported that the database connection pool had reached capacity. This was immediately followed by query timeouts, indicating that requests were no longer being serviced within acceptable time limits. Within minutes, the system progressed to repeated ECONNREFUSED errors, confirming that the database had become completely unreachable.

At the system level, a Python process consuming a large amount of memory (~500MB) was identified. While total system memory was not fully exhausted, the presence of memory pressure likely contributed to reduced performance and resource contention, which may have affected the database’s ability to handle connections efficiently.

Additionally, filesystem analysis revealed a large (~200MB) rotated log file in /var/log/kijanikiosk, indicating a failure in log rotation or cleanup. While disk space is not yet critically low, this represents a misconfiguration that could lead to future resource exhaustion and further degrade performance if left unaddressed.

Taken together, the evidence suggests a multi-factor degradation scenario:

* Increasing database load led to connection pool exhaustion
* Queries began timing out due to resource contention
* The database eventually stopped accepting connections
* Concurrent memory pressure exacerbated system instability
* Log management issues indicate poor operational hygiene, increasing long-term risk

This combination of factors explains the observed increase in API latency from approximately 120ms to 480ms, as requests were delayed or failed due to backend unavailability.

## Recommended Next Steps

1. Investigate and stabilize the database service

   * Check database process health, connection limits, and resource usage
   * Restart the database if necessary and monitor connection pool behavior

2. Terminate or limit the memory-intensive Python process

   * Free system resources to reduce contention and improve overall system responsiveness

3. Implement proper log rotation and retention policies

   * Configure automated log rotation to prevent uncontrolled log growth and avoid future disk-related issues
