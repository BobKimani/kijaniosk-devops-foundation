# Reflection

## 1. Translation trade-off in the demo

One moment that felt like overclaiming was describing the deployment as “switching traffic safely with no downtime.” In reality, there are brief moments (like during nginx reload or backend failure) where users may see errors such as a 502 response. To be more precise without confusing a non-technical audience, I would say: “We switch traffic in a controlled way that minimizes disruption, and if something goes wrong, the system quickly recovers automatically.”

## 2. Highest-value action item

The most valuable action item from the incident was improving post-deployment monitoring with a short delay before verification. This prevents false negatives caused by transient states during reload. I am moderately confident this would prevent recurrence of the same issue, but to be fully certain, I would need deeper visibility into timing behavior of the proxy reload, service startup time, and how health checks are implemented in the actual production pipeline.

## 3. What carries forward to Kubernetes

Conceptually, the ideas of health checks, automated rollback, and separating environments carry forward directly into Kubernetes. However, the implementation changes significantly. State files, manual scripts like switch-env.sh, and nginx-based routing become redundant because Kubernetes handles traffic routing, health probes, and rollbacks through deployments and services. The logic remains the same, but responsibility shifts from custom scripts to the platform.
