# Original macOS/JDK 21 evidence for #3592

Published 1 November 2026 for Wancheng Xu's implementation task, with Codex assistance. These are historical executions from 21 October, not new test runs.

## Version linkage and results

The recorded HEAD is test commit `e1fc0d5baeb5966c789a2f4f7dd2d8bd6307a05e` in both runs. The fixed run used an uncommitted production patch. Its `3592-green/diff.patch` matches the final production commit `566bace5dd8a2ed573de6b66c633176fc8e227ad` diff byte for byte (SHA256 `dc8f99c5e852f2074cf591c7b913e8f5fbca619ad83b3d15ac3d098e063b9ea5`). The final commit leaves the tests unchanged. This linkage was checked on 1 November.

- Baseline: 28 selected tests, 21 passed, 7 expected custom-message failures; exit 1.
- Fixed: same 28 tests, all passed, no errors/skips; exit 0.
- Fixed Spotless Java, Checkstyle Main/Test passed.
- Microsoft OpenJDK 21.0.12, Gradle 8.14.2, macOS arm64.
- Commands, UTC timestamps, exit codes and suites are in each `result.json`; original console output and JUnit XML are beside it.
- `no-retry.gradle` disables retries and test up-to-date reuse; commands disable build cache. Some compilation tasks remained up to date.
- No full-core, multi-module or remote CI execution is claimed by this package.

## Preservation and privacy

Original local files were verified against the pre-existing SHA256 manifest: all matched. Sharing copies replace only `/Users/miles` with `/Users/REDACTED` and the machine hostname with `REDACTED-HOST.local`. `publication-manifest.json` records original and published hashes for every file. Results, timestamps, patches and commands are otherwise unchanged; original local bytes are retained.

The earlier review/comment drafts are historical documents. Their statements that the fix was uncommitted/unpushed and review pending described 21 October and are superseded by the final commit and subsequent issue/PR review. The runner includes historical #3378 work; this publication concerns only its #3592 runs.

Implementation and regression tests are integrated in internal PR #5 and upstream PR https://github.com/mockito/mockito/pull/3901. Remaining broader validation and final group/tutor/maintainer approval continue there. This evidence publication does not claim approval to merge.
