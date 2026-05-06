# Week 8 Friday Reflection

## 1. Hardest step to automate in a CI/CD pipeline

The hardest step to make reliable in a single automated pipeline would be the deployment verification after the image has been pushed and applied to the cluster. Building and pushing the image are mostly deterministic if the registry credentials are valid, but deployment verification depends on more moving parts: the registry must be reachable, the image tag must match exactly, the cluster must be healthy, the image pull secret must still work, and the service must route traffic to the correct Pods.

The failure mode that concerns me most is an image tag mismatch between the pushed image and the deployment manifest. In an automated run, that would produce Pods that cannot pull the image, even though the build and push stages may have succeeded. To reduce this risk, the pipeline should generate the version tag once, store it as a pipeline variable, reuse it for both the push and deployment update, and then verify that the running service reports the expected version.

## 2. Rewriting one Nia sentence for Tendo

Plain sentence from the Nia document: The deployed version is no longer described only by a general version name.

Technical version for Tendo: The container image is tagged using the package version and the seven-character Git SHA, then the same immutable tag is referenced in the Kubernetes Deployment manifest and verified through the service health response.

What is lost in the plain version is implementation detail. It does not explain exactly how the version is computed, where it is applied, or how it is verified after deployment. What is gained is clarity for a non-technical reader. Nia can understand the operational value without needing to understand image tags, Git commits, or deployment manifests.

## 3. Hardcoded values that should move to ConfigMaps or Secrets in Week 9

The application port is currently hardcoded in the deployment and service definitions. It should move to configuration because different environments may expose the service differently. Keeping it hardcoded creates a risk that staging or production changes require editing deployment structure instead of changing environment configuration.

The image registry path is also hardcoded in the deployment. The image tag should remain traceable, but registry locations can differ between local, staging, and production environments. If it stays hardcoded, promoting the same service across environments becomes manual and error-prone.

The application version is currently injected directly through the deployment environment values. It is useful for traceability, but in a stronger pipeline it should be generated automatically by the delivery process rather than manually edited. If it stays manual, the running service could report a version that does not match the image actually deployed.

Any environment variables used by the payments service, such as database URLs, API base URLs, credentials, payment provider settings, or feature flags, should move into ConfigMaps or Secrets. Non-sensitive values belong in ConfigMaps, while passwords, tokens, and private keys belong in Secrets. If these values stay inside the manifest, each environment needs a separate edited deployment file, and sensitive information may accidentally be committed to the repository.

Resource values such as CPU and memory requests and limits may also become environment-specific. They are safe to keep visible, but they may need configuration management if staging and production use different capacity profiles. If they remain fixed everywhere, the service may be oversized in development or under-resourced in production.
