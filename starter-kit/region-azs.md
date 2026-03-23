# Region and Availability Zone Design

## Region Selection

The system should be deployed in a region close to its primary users to reduce latency.

Thus for KijaniKiosk, this would ideally be a region geographically close to its user base to ensure fast response times.

## Availability Zones (AZs)

The system should be deployed across multiple availability zones within the same region.

## Reliability Reasoning

Using multiple Availability Zones ensures:
- High availability in case one data center fails
- Fault isolation between infrastructure components
- Improved system resilience due to redundancy of instances

For example:
- Application servers can run in AZ1 and AZ2
- If AZ1 fails, traffic is routed to AZ2

## Conclusion

A multi-AZ architecture ensures that the system remains available even during partial infrastructure failures, which is critical for a customer-facing platform.
