# kk-payments SLI and SLO Definition

## Purpose

This document defines what `kk-payments` measures, what reliability targets it commits to, and which short-window signals should trigger an automated rollback during deployment. The goal is to make release safety measurable instead of depending on a person watching the deployment manually.

## Scope

This document applies to the customer-facing payment path. It focuses on three service signals: whether payment requests can be served, whether they respond fast enough, and whether valid payment attempts fail because of the service.

---

## SLI 1: Availability

### Definition

Availability measures the percentage of valid payment requests that receive a successful service response from the active environment.

### Data source

The data source is the active proxy health endpoint, application request logs, and payment endpoint response logs.

### Calculation method

availability = successful valid requests / total valid requests \* 100

### Measurement window

The long-term measurement window is a rolling 30-day period.

### SLO target

kk-payments should maintain at least 99.9% availability over a rolling 30-day window.

---

## SLI 2: Latency

### Definition

Latency measures how long the active payment service takes to respond to valid payment requests.

### Data source

The data source is application request logs from the payment endpoint. Each log entry should include request start time, response completion time, route name, response status, and active environment.

### Calculation method

Latency is measured using the 95th percentile response time.

p95 latency = the response time below which 95% of valid payment requests complete

### Measurement window

The long-term measurement window is a rolling 30-day period.

### SLO target

At least 95% of valid payment requests should complete within 500 milliseconds over a rolling 30-day window.

---

## SLI 3: Payment Error Rate

### Definition

Payment error rate measures the percentage of valid payment attempts that fail because of a service-side or payment-processing problem.

### Data source

The data source is payment application logs and payment result records. Each record should include timestamp, request identifier, payment result, response code, and active environment.

### Calculation method

payment error rate = failed valid payment attempts / total valid payment attempts \* 100

### Measurement window

The long-term measurement window is a rolling 30-day period.

### SLO target

The valid payment error rate should remain below 0.5% over a rolling 30-day window.

---

## Rollback Thresholds

| Signal             | 30-day SLO target                                    | Short-window rollback threshold                                                 | Source                                              | Reason                                                                                                                                                                       |
| ------------------ | ---------------------------------------------------- | ------------------------------------------------------------------------------- | --------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Availability       | At least 99.9% successful valid requests             | Three consecutive failed health checks or availability below 98% for 60 seconds | Active proxy health checks and payment request logs | A new release that immediately fails health checks can consume the monthly error budget quickly, so it should be removed from traffic before customers are widely affected.  |
| Latency            | 95% of valid payment requests complete within 500 ms | p95 latency above 1500 ms for 60 seconds after deployment                       | Payment request logs                                | The rollback threshold is higher than the normal target to avoid rollback from one small spike, but it still catches a release that makes the payment path clearly too slow. |
| Payment error rate | Less than 0.5% valid payment error rate              | More than 2% valid payment failures for 60 seconds after deployment             | Payment result logs                                 | A 2% short-window error rate is much worse than the monthly target and suggests a release-specific fault instead of normal background failure.                               |

---

## Relationship Between SLO Targets and Rollback Thresholds

The SLO targets describe what the service commits to over a 30-day period. The rollback thresholds are shorter because deployment failures must be detected quickly. A new release may not break the 30-day target immediately, but it can start consuming the error budget too quickly. For that reason, rollback is triggered when the active release shows clear short-window evidence of customer harm.

The rollback thresholds are intentionally not identical to the SLO targets. They are designed to catch severe release problems quickly while avoiding rollback from one temporary or isolated failure.

---

## What We Do Not Commit To

External payment provider uptime is not guaranteed because banks and mobile money systems are outside the control of kk-payments.

Customer device or network performance is not guaranteed because performance can vary based on the user’s device and internet connection.

Payment approval rate is not guaranteed because valid payments may be declined due to insufficient funds, fraud checks, or bank policies.

Manual finance reconciliation time is not guaranteed because it depends on internal business processes outside the payment service.
