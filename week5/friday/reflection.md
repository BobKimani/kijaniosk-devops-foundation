# Reflection

## 1. Where two requirements were in tension

The clearest tension was between keeping the package simple and making the artifact look production-ready. At first, `npm pack` was including large parts of the repository, including older coursework folders and setup files. That would still have produced an artifact, but it would not have represented a clean release package. I chose to prioritise artifact quality by restricting the package contents to the application source through the `files` section in `package.json`. That decision made the final package smaller, cleaner, and easier to defend.

## 2. One sentence written for two audiences

Board-facing version:
Every time a developer sends in new work, the pipeline checks quality, runs tests, creates a versioned package, and stores that package in a central registry only if every earlier check succeeds.

Technical version:
The Jenkins pipeline runs lint, build, parallel verify, archive, and publish stages, and it blocks downstream stages when an upstream stage fails.

The information is the same in both versions: both explain the order of checks and the fact that release only happens after success. What changes is the language. The board version focuses on business meaning and control, while the technical version focuses on implementation details and stage behaviour.

## 3. What would break first if the team grew from four developers to forty

The first part likely to break would be the simplicity of the release flow around a single published package and a single job definition. With more developers, build frequency and change volume would increase, and the team would need better branch policies, clearer package ownership, and stronger control over how concurrent changes are tested and published. The pipeline itself is fast and reliable for a small project, but at a larger scale it would need stronger governance around branch strategy, promotion between environments, and possibly separate build and release jobs to reduce contention.
