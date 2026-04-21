# KijaniKiosk CI Pipeline Overview

The pipeline built this week is an automated quality and release process for the KijaniKiosk payments package. Its purpose is simple: every time a developer sends new code to the shared repository, the pipeline checks that the change is safe, consistent, and ready to be stored as a traceable release. This reduces the risk of human error, shortens the time needed to verify changes, and gives the team a dependable record of what was built and when.

| Stage   | What it confirms                                                             | Why it matters to the business                                               |
| ------- | ---------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| Lint    | The code follows agreed quality and formatting rules.                        | Stops avoidable mistakes early and keeps the codebase maintainable.          |
| Build   | The project can complete its defined build step successfully.                | Confirms the package is structurally ready to move forward.                  |
| Verify  | Tests pass and the dependency audit does not report serious security issues. | Protects reliability and reduces the chance of shipping vulnerable software. |
| Archive | A versioned package file is created and recorded.                            | Creates a traceable release artifact that can be reviewed or reused later.   |
| Publish | The package is stored in the internal registry.                              | Makes the approved version available from a central, controlled location.    |

The process starts when a developer pushes code to the feature branch in GitHub. Jenkins then reads the pipeline definition stored in the repository itself, which means the release logic is version-controlled alongside the code. The pipeline runs inside a fixed Docker-based Node.js environment, which is important because it makes each run consistent. Instead of depending on whatever tools happen to exist on a machine at a given moment, the pipeline uses a known environment every time. That makes failures easier to understand and makes successful runs easier to trust.

The first stage checks code quality rules. This is a fast screening step designed to catch simple problems before more time is spent. If that stage passes, the pipeline runs the build step. In this project the build step is lightweight, but it still plays an important role because it proves the package can move through its expected preparation step successfully.

After that, the pipeline enters a verification stage with two checks running at the same time. One check runs the automated tests. The other checks the project dependencies for serious security issues. Running these in parallel makes the process faster without weakening control. If both pass, the pipeline creates a packaged release file and records it with a fingerprint so it can be traced later. That release file is then published to Nexus, which is the team’s internal package registry. In practical terms, Nexus acts as a controlled storage point for approved build outputs. Instead of leaving release files scattered across developer machines, the team stores them in one predictable place.

Each published package uses a version number that combines the base software version with a short Git commit identifier. This matters because it gives the team immediate traceability. A package can be linked back to the exact code change that produced it. For a financial services platform, that kind of traceability is important for controlled release practices, troubleshooting, and rollback decisions.

## What Happens When Something Goes Wrong

If any stage fails, the pipeline stops immediately and later release steps do not continue. For example, if the code quality check fails, the package is not built. If tests fail, the package is not archived or published. If the registry cannot be reached securely, the package is not released. This design protects the business by ensuring that an unfinished or unsafe change cannot quietly move into the release store. The result is a clear rule: only changes that pass every required check become available as approved package versions.

What this pipeline does not yet do is deploy the package into a test or production environment. At this stage, it focuses on quality control, packaging, traceability, and controlled storage. That is an honest and useful boundary. It means the team now has a reliable continuous integration process and a dependable package history, but a later stage would still be needed to automate promotion into live environments.
