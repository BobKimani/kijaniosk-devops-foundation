# IAM Least Privilege Design

## Use Case

The application needs to store and retrieve product images from cloud storage.

## IAM Policy Design

The policy grants only the permissions required for this task:

- Read objects
- Write objects

It does NOT allow:
- Deleting storage buckets
- Managing users or permissions
- Accessing unrelated services

Following the least privilege principle, it would look like this:
## Example Policy

```json
{
  "Effect": "Allow",
  "Action": [
    "storage:PutObject",
    "storage:GetObject"
  ],
  "Resource": "arn:cloud:storage:product-images/*"
}
