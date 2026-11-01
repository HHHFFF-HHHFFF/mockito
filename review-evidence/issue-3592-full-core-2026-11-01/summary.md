# #3592 full-core verification — 1 November 2026

Actual production commit: `566bace5dd8a2ed573de6b66c633176fc8e227ad`; Microsoft OpenJDK 21.0.12, macOS arm64, Gradle 8.14.2.

Fresh full-core run: **2327 passed, 72 skipped, 0 failures, 0 errors** (2399 total). The 12 new and 16 existing DoNotMock tests all passed. Command exit code 0. `:mockito-core:test`, `:mockito-core:check` and `:mockito-core:spotlessCheck` completed successfully.

Tests were forced to execute by the init script; retries and build cache were disabled; one worker was used. Some compilation and static-check tasks were UP-TO-DATE; see the complete log for executed vs reused tasks. This is not a multi-module run or the upstream CI matrix. Production and test source files were unchanged.

The command, environment, exact revision, UTC start/end times and XML totals are recorded in `result.json`; console output is in `gradle.log`; original JUnit results are in `xml/`.

Upstream PR #3901 run 41266725385 and #3902 run 41266739678 both reported `action_required` with zero jobs during this check. There is no remote pass/fail test result. This likely needs maintainer workflow approval; the API did not expose an explicit approval reason. See `ci-status.json`.
